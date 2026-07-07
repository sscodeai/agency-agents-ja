#!/usr/bin/env python3
"""Build the Hermes lazy-router plugin for agency-agents-ja."""
from __future__ import annotations

import argparse
import json
import re
import shutil
import textwrap
from pathlib import Path

PLUGIN_NAME = "agency-agents-router"


def division_dirs(repo_root: Path) -> list[str]:
    data = json.loads((repo_root / "divisions.json").read_text(encoding="utf-8"))
    return sorted(data["divisions"].keys())


def slugify(value: str) -> str:
    value = value.lower()
    value = re.sub(r"[^a-z0-9]+", "-", value)
    return value.strip("-")


def parse_agent(path: Path, repo_root: Path) -> dict[str, str] | None:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        return None
    parts = text.split("---\n", 2)
    if len(parts) < 3:
        return None
    frontmatter = parts[1]
    body = parts[2].lstrip("\n")
    fields: dict[str, str] = {}
    for line in frontmatter.splitlines():
        if ":" not in line or line.startswith((" ", "\t")):
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip().strip('"').strip("'")
    name = fields.get("name", "").strip()
    if not name:
        return None
    rel = path.relative_to(repo_root)
    division = rel.parts[0]
    slug = slugify(path.stem)
    return {
        "slug": slug,
        "name": name,
        "description": fields.get("description", "").strip(),
        "division": division,
        "color": fields.get("color", "").strip(),
        "emoji": fields.get("emoji", "").strip(),
        "source": fields.get("source", "").strip(),
        "translation_status": fields.get("translation_status", "").strip(),
        "upstream_path": fields.get("upstream_path", "").strip(),
        "source_path": str(rel),
        "body": body,
    }


def collect_agents(repo_root: Path) -> list[dict[str, str]]:
    agents: list[dict[str, str]] = []
    for dirname in division_dirs(repo_root):
        base = repo_root / dirname
        if not base.is_dir():
            continue
        for path in sorted(base.rglob("*.md")):
            parsed = parse_agent(path, repo_root)
            if parsed:
                agents.append(parsed)
    agents.sort(key=lambda item: (item["division"], item["slug"]))
    seen: set[str] = set()
    duplicates: set[str] = set()
    for agent in agents:
        slug = agent["slug"]
        if slug in seen:
            duplicates.add(slug)
        seen.add(slug)
    if duplicates:
        dupes = ", ".join(sorted(duplicates))
        raise SystemExit(f"duplicate Hermes agent slugs: {dupes}")
    return agents


def plugin_yaml() -> str:
    return textwrap.dedent(
        f"""
        name: {PLUGIN_NAME}
        version: 1.0.0
        description: Lazy search/load/delegate router for the agency-agents-ja specialist roster.
        provides_tools:
          - agency_agents_search
          - agency_agents_inspect
          - agency_agents_load
          - agency_agents_delegate
        """
    ).lstrip()


def init_py() -> str:
    return r'''"""Hermes plugin: lazy router for agency-agents-ja."""
from __future__ import annotations

import json
import math
import re
from pathlib import Path
from typing import Any

_DATA_PATH = Path(__file__).parent / "data" / "agents.json"
_AGENTS: list[dict[str, Any]] | None = None
_WORD_RE = re.compile(r"[a-z0-9][a-z0-9+.#_-]*", re.I)


def _load_agents() -> list[dict[str, Any]]:
    global _AGENTS
    if _AGENTS is None:
        _AGENTS = json.loads(_DATA_PATH.read_text(encoding="utf-8"))
    return _AGENTS


def _tokens(text: str) -> set[str]:
    return {token.lower() for token in _WORD_RE.findall(text or "")}


def _agent_lookup(identifier: str) -> dict[str, Any] | None:
    needle = (identifier or "").strip().lower()
    if not needle:
        return None
    slug = re.sub(r"[^a-z0-9]+", "-", needle).strip("-")
    for agent in _load_agents():
        if agent["slug"] == slug or agent["name"].lower() == needle:
            return agent
    return None


def _identifier(args: dict[str, Any]) -> str:
    return str(args.get("agent") or args.get("slug") or "").strip()


def _not_found(identifier: str) -> str:
    return _json({
        "success": False,
        "error": "agent not found" if identifier else "agent or slug is required",
        "agent": identifier or None,
    })


def _score(agent: dict[str, Any], query_tokens: set[str], query_text: str) -> float:
    haystack_fields = [
        agent.get("name", ""),
        agent.get("description", ""),
        agent.get("division", ""),
        agent.get("source", ""),
        agent.get("translation_status", ""),
        agent.get("body", "")[:8000],
    ]
    haystack_text = "\n".join(haystack_fields).lower()
    haystack_tokens = _tokens(haystack_text)
    overlap = query_tokens & haystack_tokens
    score = float(len(overlap))
    if query_text and query_text in haystack_text:
        score += 5.0
    name = agent.get("name", "").lower()
    description = agent.get("description", "").lower()
    for token in query_tokens:
        if token in name:
            score += 3.0
        if token in description:
            score += 1.5
    if score == 0.0:
        return 0.0
    return score + (1.0 / math.sqrt(max(len(haystack_tokens), 1)))


def _summary(agent: dict[str, Any], score: float | None = None) -> dict[str, Any]:
    item = {
        "slug": agent["slug"],
        "name": agent["name"],
        "division": agent["division"],
        "description": agent.get("description", ""),
        "source": agent.get("source", ""),
        "translation_status": agent.get("translation_status", ""),
        "source_path": agent.get("source_path", ""),
    }
    if score is not None:
        item["score"] = round(score, 3)
    return item


def _specialist_prompt(agent: dict[str, Any], task: str = "") -> str:
    task_block = f"\n\n## User task\n{task.strip()}\n" if task and task.strip() else ""
    return (
        "Use the following agency-agents-ja specialist context for this turn. "
        "Adopt the specialist's relevant standards and checklists, but obey the "
        "user's current request and higher-priority system/developer instructions.\n\n"
        f"# {agent['name']} ({agent['slug']})\n\n"
        f"Division: {agent.get('division', '')}\n"
        f"Description: {agent.get('description', '')}\n"
        f"Source: {agent.get('source_path', '')}\n"
        f"{task_block}\n\n"
        f"## Specialist instructions\n{agent.get('body', '')}"
    )


def _json(payload: dict[str, Any]) -> str:
    return json.dumps(payload, ensure_ascii=False, indent=2)


def agency_agents_search(query: str, division: str = "", limit: int = 8) -> str:
    query_text = (query or "").strip().lower()
    query_tokens = _tokens(query_text)
    limit = max(1, min(int(limit or 8), 25))
    candidates = []
    for agent in _load_agents():
        if division and agent.get("division") != division:
            continue
        score = _score(agent, query_tokens, query_text)
        if score > 0:
            candidates.append((score, agent))
    candidates.sort(key=lambda item: item[0], reverse=True)
    return _json({
        "query": query,
        "division": division or None,
        "count": len(candidates),
        "results": [_summary(agent, score) for score, agent in candidates[:limit]],
    })


def agency_agents_inspect(agent: str = "", slug: str = "", include_body: bool = False) -> str:
    identifier = _identifier({"agent": agent, "slug": slug})
    found = _agent_lookup(identifier)
    if not found:
        return _not_found(identifier)
    payload = _summary(found)
    payload["upstream_path"] = found.get("upstream_path", "")
    if include_body:
        payload["body"] = found.get("body", "")
    return _json(payload)


def agency_agents_load(agent: str = "", slug: str = "", task: str = "") -> str:
    identifier = _identifier({"agent": agent, "slug": slug})
    found = _agent_lookup(identifier)
    if not found:
        return _not_found(identifier)
    return _specialist_prompt(found, task)


def agency_agents_delegate(agent: str = "", slug: str = "", task: str = "") -> str:
    identifier = _identifier({"agent": agent, "slug": slug})
    found = _agent_lookup(identifier)
    if not found:
        return _not_found(identifier)
    prompt = _specialist_prompt(found, task)
    delegate = globals().get("delegate_task")
    if callable(delegate):
        return delegate(prompt)
    return prompt
'''


def readme(agent_count: int) -> str:
    return textwrap.dedent(
        f"""
        # Hermes Agency Agents Router Plugin

        Generated by `scripts/convert.sh --tool hermes`.

        This integration installs one Hermes plugin named `agency-agents-router`
        instead of preloading the full `agency-agents-ja` roster as skills.
        Hermes sees a small fixed tool surface at startup, while the complete
        roster is stored on disk in `data/agents.json` and searched/loaded lazily.

        Generated agent count: {agent_count}

        ## Tools exposed to Hermes

        - `agency_agents_search` — find matching specialists by query/division.
        - `agency_agents_inspect` — inspect one specialist's metadata or full body.
        - `agency_agents_load` — compose one specialist prompt for the current task.
        - `agency_agents_delegate` — delegate through Hermes `delegate_task` when available.

        ## Install

        ```bash
        ./scripts/convert.sh --tool hermes
        ./scripts/install.sh --tool hermes
        ```
        """
    ).lstrip()


def build(repo_root: Path, out_dir: Path) -> None:
    agents = collect_agents(repo_root)
    plugin_dir = out_dir / PLUGIN_NAME
    if plugin_dir.exists():
        shutil.rmtree(plugin_dir)
    (plugin_dir / "data").mkdir(parents=True)
    (plugin_dir / "plugin.yaml").write_text(plugin_yaml(), encoding="utf-8")
    (plugin_dir / "__init__.py").write_text(init_py(), encoding="utf-8")
    (plugin_dir / "README.md").write_text(readme(len(agents)), encoding="utf-8")
    (plugin_dir / "data" / "agents.json").write_text(
        json.dumps(agents, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(f"Wrote {plugin_dir} ({len(agents)} agents)")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--out", default="integrations/hermes")
    args = parser.parse_args()
    build(Path(args.repo_root).resolve(), Path(args.out).resolve())


if __name__ == "__main__":
    main()
