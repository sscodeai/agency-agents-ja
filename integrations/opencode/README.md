# OpenCode Integration

Do not copy source agent files directly into `.opencode/agents/`.

```bash
# Wrong: source frontmatter can contain fields OpenCode does not accept.
cp agency-agents-ja/engineering/*.md .opencode/agents/

# Right: convert and install through the repository scripts.
/path/to/agency-agents-ja/scripts/install.sh --tool opencode
```

The installer writes converted OpenCode files with compatible frontmatter,
including `mode: subagent` and normalized hex colors.

OpenCode agents are `.md` files with YAML frontmatter stored in
`.opencode/agents/`. The converter maps named colors to hex codes and adds
`mode: subagent` so agents are invoked on-demand via `@agent-name` rather
than cluttering the primary agent picker.

## Install

```bash
# Run from your project root
cd /your/project
/path/to/agency-agents-ja/scripts/install.sh --tool opencode
```

This creates `.opencode/agents/<slug>.md` files in your project directory.

## Activate an Agent

In OpenCode, invoke a subagent with the `@` prefix:

```
@frontend-developer help build this component.
```

```
@reality-checker review this PR.
```

You can also select agents from the OpenCode UI's agent picker.

## Agent Format

Each generated agent file contains:

```yaml
---
name: Frontend Developer
description: Expert frontend developer specializing in modern web technologies...
mode: subagent
color: "#00FFFF"
---
```

- **mode: subagent** — agent is available on-demand, not shown in the primary Tab-cycle list
- **color** — hex code (named colors from source files are converted automatically)

## Project vs Global

Agents in `.opencode/agents/` are **project-scoped**. To make them available
globally across all projects, first generate the agent files, then install
with `OPENCODE_AGENTS_DIR`:

```bash
./scripts/convert.sh --tool opencode
OPENCODE_AGENTS_DIR=~/.config/opencode/agents ./scripts/install.sh --tool opencode
```

## Regenerate

```bash
./scripts/convert.sh --tool opencode
```
