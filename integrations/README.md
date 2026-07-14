# 🔌 Integrations

This directory contains The Agency integrations and converted formats for
supported agentic coding tools.

## Supported Tools

- **[Claude Code](#claude-code)** — `.md` agents, use the repo directly
- **[GitHub Copilot](#github-copilot)** — `.md` agents, use the repo directly
- **[Antigravity](#antigravity)** — `SKILL.md` per agent in `antigravity/`
- **[Gemini CLI](#gemini-cli)** — extension + `SKILL.md` files in `gemini-cli/`
- **[OpenCode](#opencode)** — `.md` agent files in `opencode/`
- **[OpenClaw](#openclaw)** — `SOUL.md` + `AGENTS.md` + `IDENTITY.md` workspaces
- **[Cursor](#cursor)** — `.mdc` rule files in `cursor/`
- **[Aider](#aider)** — `CONVENTIONS.md` in `aider/`
- **[Windsurf](#windsurf)** — `.windsurfrules` in `windsurf/`
- **[Kimi Code](#kimi-code)** — YAML agent specs in `kimi/`
- **[Qwen Code](#qwen-code)** — project-scoped `.md` SubAgents in `.qwen/agents/`
- **[ZCode](zcode/README.md)** — `.md` agent files in `zcode/`
- **[Codex](codex/README.md)** — `.toml` custom agents in `codex/`
- **[Osaurus](osaurus/README.md)** — `SKILL.md` skills in `osaurus/`
- **[Hermes](hermes/README.md)** — lazy-router plugin in `hermes/`
- **[Mistral Vibe](vibe/README.md)** — TOML agents and Markdown prompts in `vibe/`

## Quick Install

```bash
# Install for all detected tools automatically
./scripts/install.sh

# Install a specific home-scoped tool
./scripts/install.sh --tool antigravity
./scripts/install.sh --tool copilot
./scripts/install.sh --tool openclaw
./scripts/install.sh --tool claude-code

# Gemini CLI needs generated integration files on a fresh clone
./scripts/convert.sh --tool gemini-cli
./scripts/install.sh --tool gemini-cli

# Qwen Code also needs generated SubAgent files on a fresh clone
./scripts/convert.sh --tool qwen
./scripts/install.sh --tool qwen

# ZCode also needs generated agent files on a fresh clone
./scripts/convert.sh --tool zcode
./scripts/install.sh --tool zcode

# Codex and Osaurus also use generated integration files
./scripts/convert.sh --tool codex
./scripts/install.sh --tool codex
./scripts/convert.sh --tool osaurus
./scripts/install.sh --tool osaurus

# Hermes uses one generated lazy-router plugin
./scripts/convert.sh --tool hermes
./scripts/install.sh --tool hermes

# Mistral Vibe uses generated TOML agents and prompt files
./scripts/convert.sh --tool vibe
./scripts/install.sh --tool vibe
```

If you install OpenClaw and the gateway is already running, restart it after installation:

```bash
openclaw gateway restart
```

For project-scoped tools such as OpenCode, Cursor, Aider, Windsurf, and Qwen
Code, run the installer from your target project root as shown in the
tool-specific sections below. ZCode installs user-wide by default; set
`ZCODE_AGENTS_DIR=.zcode/agents` for a project-scoped install.

## Regenerating Integration Files

If you add or modify agents, regenerate all integration files:

```bash
./scripts/convert.sh
```

---

## Claude Code

The Agency was originally designed for Claude Code. Agents work natively
without conversion.

```bash
cp -r <category>/*.md ~/.claude/agents/
# or install everything at once:
./scripts/install.sh --tool claude-code
```

See [claude-code/README.md](claude-code/README.md) for details.

---

## GitHub Copilot

The Agency also works natively with GitHub Copilot. Agents can be copied
directly into `~/.github/agents/` and `~/.copilot/agents/` without conversion.

```bash
./scripts/install.sh --tool copilot
```

See [github-copilot/README.md](github-copilot/README.md) for details.

---

## Antigravity

Skills are installed globally to `~/.gemini/config/skills/`. Antigravity also
reads project-scoped skills from `<project>/.agents/skills/`. Each agent becomes
a separate skill prefixed with `agency-` to avoid naming conflicts.

```bash
./scripts/install.sh --tool antigravity
```

See [antigravity/README.md](antigravity/README.md) for details.

---

## Gemini CLI

Agents are packaged as a Gemini CLI extension with individual skill files.
The extension is installed to `~/.gemini/extensions/agency-agents/`.
Because the Gemini manifest and skill folders are generated artifacts, run
`./scripts/convert.sh --tool gemini-cli` before installing from a fresh clone.

```bash
./scripts/convert.sh --tool gemini-cli
./scripts/install.sh --tool gemini-cli
```

See [gemini-cli/README.md](gemini-cli/README.md) for details.

---

## OpenCode

Each agent becomes a project-scoped `.md` file in `.opencode/agents/`.

```bash
cd /your/project && /path/to/agency-agents-ja/scripts/install.sh --tool opencode
```

See [opencode/README.md](opencode/README.md) for details.

---

## OpenClaw

Each agent becomes an OpenClaw workspace containing `SOUL.md`, `AGENTS.md`,
and `IDENTITY.md`.

Before installing, generate the OpenClaw workspaces:

```bash
./scripts/convert.sh --tool openclaw
```

Then install them:

```bash
./scripts/install.sh --tool openclaw
```

See [openclaw/README.md](openclaw/README.md) for details.

---

## Cursor

Each agent becomes a `.mdc` rule file. Rules are project-scoped — run the
installer from your project root.

```bash
cd /your/project && /path/to/agency-agents-ja/scripts/install.sh --tool cursor
```

See [cursor/README.md](cursor/README.md) for details.

---

## Aider

All agents are consolidated into a single `CONVENTIONS.md` file that Aider
reads automatically when present in your project root.

```bash
cd /your/project && /path/to/agency-agents-ja/scripts/install.sh --tool aider
```

See [aider/README.md](aider/README.md) for details.

---

## Windsurf

All agents are consolidated into a single `.windsurfrules` file for your
project root.

```bash
cd /your/project && /path/to/agency-agents-ja/scripts/install.sh --tool windsurf
```

See [windsurf/README.md](windsurf/README.md) for details.

---

## Kimi Code

Each agent is converted to a Kimi Code CLI agent specification (YAML format with
separate system prompt files). Agents are installed to `~/.config/kimi/agents/`.

Because the Kimi agent files are generated from the source Markdown, run
`./scripts/convert.sh --tool kimi` before installing from a fresh clone.

```bash
./scripts/convert.sh --tool kimi
./scripts/install.sh --tool kimi
```

### Usage

After installation, use an agent with the `--agent-file` flag:

```bash
kimi --agent-file ~/.config/kimi/agents/frontend-developer/agent.yaml
```

Or in a specific project:

```bash
cd /your/project
kimi --agent-file ~/.config/kimi/agents/frontend-developer/agent.yaml \
     --work-dir /your/project
```

See [kimi/README.md](kimi/README.md) for details.

---

## Qwen Code

Each agent becomes a project-scoped `.md` SubAgent file in `.qwen/agents/`.

From a fresh clone, generate the Qwen files first:

```bash
./scripts/convert.sh --tool qwen
```

Then install them from your project root:

```bash
cd /your/project && /path/to/agency-agents-ja/scripts/install.sh --tool qwen
```

See [qwen/README.md](qwen/README.md) for details.

---

## ZCode

Each agent becomes a Markdown agent file in `integrations/zcode/agents/`.
From a fresh clone, generate the ZCode files before installing.

```bash
./scripts/convert.sh --tool zcode
./scripts/install.sh --tool zcode
```

For a project-scoped install:

```bash
cd /your/project
ZCODE_AGENTS_DIR=.zcode/agents /path/to/agency-agents-ja/scripts/install.sh --tool zcode
```

See [zcode/README.md](zcode/README.md) for details.

---

## Codex

Each agent becomes a Codex custom agent TOML file.

```bash
./scripts/convert.sh --tool codex
./scripts/install.sh --tool codex
```

See [codex/README.md](codex/README.md) for details.

---

## Osaurus

Each agent becomes an Osaurus `SKILL.md` skill.

```bash
./scripts/convert.sh --tool osaurus
./scripts/install.sh --tool osaurus
```

See [osaurus/README.md](osaurus/README.md) for details.

---

## Hermes

Hermes installs one generated lazy-router plugin instead of preloading every
agent.

```bash
./scripts/convert.sh --tool hermes
./scripts/install.sh --tool hermes
```

See [hermes/README.md](hermes/README.md) for details.

---

## Mistral Vibe

Each agent becomes a TOML agent file plus a Markdown prompt file.

```bash
./scripts/convert.sh --tool vibe
./scripts/install.sh --tool vibe
```

See [vibe/README.md](vibe/README.md) for details.
