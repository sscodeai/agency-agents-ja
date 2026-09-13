#!/usr/bin/env python3
"""Regression tests for the Hermes config rewrite heredoc in install.sh.

The test is intentionally dependency-free. It validates the text invariants
that matter for this bug: the plugin is inserted as its own list item, existing
list-item indentation is preserved, corrupted glued list items are split, and
running the rewrite twice is idempotent.
"""

from __future__ import annotations

import re
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path

INSTALL_SH = Path(__file__).resolve().parent / "install.sh"
PLUGIN = "agency-agents-router"


def extract_heredoc(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    pattern = re.compile(
        r"""python3 - "\$config" "\$plugin" <<'PY'\n(.+?)\nPY\n""",
        re.DOTALL,
    )
    match = pattern.search(text)
    if not match:
        raise SystemExit(f"heredoc not found in {path}")
    return match.group(1)


def run_once(heredoc: str, cfg_text: str) -> tuple[str | None, str | None]:
    with tempfile.TemporaryDirectory() as tmp:
        path = Path(tmp) / "config.yaml"
        path.write_text(cfg_text, encoding="utf-8")
        result = subprocess.run(
            ["python3", "-", str(path), PLUGIN],
            input=heredoc,
            capture_output=True,
            text=True,
            timeout=10,
        )
        if result.returncode != 0:
            return None, f"exit={result.returncode} stderr={result.stderr[:200]}"
        return path.read_text(encoding="utf-8"), None


def enabled_item_lines(text: str) -> list[str]:
    lines = text.splitlines()
    in_plugins = False
    in_enabled = False
    enabled_indent = 0
    items: list[str] = []
    for line in lines:
        if line.startswith("plugins:"):
            in_plugins = True
            in_enabled = False
            continue
        if in_plugins and line and not line.startswith((" ", "\t")):
            break
        stripped = line.strip()
        if in_plugins and stripped == "enabled:":
            in_enabled = True
            enabled_indent = len(line) - len(stripped)
            continue
        if in_enabled:
            indent = len(line) - len(stripped)
            if stripped and indent <= enabled_indent:
                break
            if stripped.startswith("-"):
                items.append(line)
            elif stripped and not line.startswith((" ", "\t")):
                break
    return items


def disabled_item_lines(text: str) -> list[str]:
    lines = text.splitlines()
    in_plugins = False
    in_disabled = False
    disabled_indent = 0
    items: list[str] = []
    for line in lines:
        if line.startswith("plugins:"):
            in_plugins = True
            in_disabled = False
            continue
        if in_plugins and line and not line.startswith((" ", "\t")):
            break
        stripped = line.strip()
        if in_plugins and stripped == "disabled:":
            in_disabled = True
            disabled_indent = len(line) - len(stripped)
            continue
        if in_disabled:
            indent = len(line) - len(stripped)
            if stripped and indent <= disabled_indent:
                break
            if stripped.startswith("-"):
                items.append(line)
    return items


def check_case(heredoc: str, name: str, cfg_text: str) -> list[str]:
    failures: list[str] = []
    out, err = run_once(heredoc, cfg_text)
    if err:
        return [f"{name}: {err}"]
    assert out is not None
    items = enabled_item_lines(out)
    plugin_lines = [line for line in items if line.strip() == f"- {PLUGIN}"]
    if len(plugin_lines) != 1:
        failures.append(f"{name}: expected one standalone plugin item, got {plugin_lines!r}")
    glued = [line for line in items if line.strip().count("- ") > 1]
    if glued:
        failures.append(f"{name}: glued list item remains: {glued!r}")
    if "old/dead" in cfg_text:
        disabled = [line.strip() for line in disabled_item_lines(out)]
        enabled = [line.strip() for line in items]
        if "- old/dead" not in disabled:
            failures.append(f"{name}: disabled item was not preserved under disabled: {disabled!r}")
        if "- old/dead" in enabled:
            failures.append(f"{name}: disabled item leaked into enabled: {enabled!r}")
    if "enabled: [basic" in cfg_text:
        enabled = [line.strip() for line in items]
        if "- basic" not in enabled:
            failures.append(f"{name}: inline enabled item was not preserved: {enabled!r}")

    out2, err2 = run_once(heredoc, out)
    if err2:
        failures.append(f"{name}: idempotent re-run failed: {err2}")
    elif out2 != out:
        failures.append(f"{name}: idempotent re-run changed output")
    return failures


def main() -> int:
    heredoc = extract_heredoc(INSTALL_SH)
    cases = [
        (
            "Hermes 4-space indent",
            textwrap.dedent("""\
                model:
                  name: x
                plugins:
                  disabled:
                    - old/dead
                  enabled:
                    - basic
                    - chronos
                    - ponytail
                session_reset:
                  foo: bar
            """),
        ),
        (
            "Corrupted glued scalar recovery",
            "model:\n  name: x\nplugins:\n  enabled:\n"
            "  - agency-agents-router - basic - chronos - ponytail\n",
        ),
        (
            "Already present",
            textwrap.dedent("""\
                model:
                  name: x
                plugins:
                  enabled:
                    - agency-agents-router
                    - basic
            """),
        ),
        (
            "Empty inline enabled",
            textwrap.dedent("""\
                model:
                  name: x
                plugins:
                  enabled: []
                other:
                  x: 1
            """),
        ),
        (
            "No plugins block",
            textwrap.dedent("""\
                model:
                  name: x
                session_reset:
                  foo: bar
            """),
        ),
        (
            "Plugins with disabled only",
            textwrap.dedent("""\
                plugins:
                  disabled:
                    - old/dead
            """),
        ),
        (
            "Disabled before empty inline enabled",
            textwrap.dedent("""\
                plugins:
                  disabled:
                    - old/dead
                  enabled: []
            """),
        ),
        (
            "Non-empty inline enabled",
            textwrap.dedent("""\
                plugins:
                  enabled: [basic]
            """),
        ),
    ]

    failures: list[str] = []
    for name, cfg in cases:
        failures.extend(check_case(heredoc, name, cfg))
    if failures:
        print(f"FAIL: {len(failures)} Hermes config rewrite regression(s)")
        for failure in failures:
            print(f"  - {failure}")
        return 1
    print(f"PASS: {len(cases)} Hermes config rewrite regression cases")
    return 0


if __name__ == "__main__":
    sys.exit(main())
