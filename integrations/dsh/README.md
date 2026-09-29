# DeepSeek Harness Integration

Installs the full `agency-agents-ja` roster as DeepSeek Harness (DSH) skills.
Each skill is prefixed with `agency-` to avoid conflicts with built-in skills.

## Generate

From the repository root:

```bash
./scripts/convert.sh --tool dsh
```

This writes one `agency-<slug>/SKILL.md` directory per agent under
`integrations/dsh/`.

## Install

```bash
./scripts/install.sh --tool dsh
```

This copies files from `integrations/dsh/` to `${DSH_HOME:-$HOME/.dsh}/skills/`
(user-wide). Set `DSH_HOME` if your Harness config lives elsewhere. For
project-scoped skills, run the installer from your project root with
`DSH_SKILLS_DIR=.dsh/skills` — this specific override takes precedence over
`DSH_HOME`, and DSH reads `<project>/.dsh/skills/` automatically.

> DSH discovers skills live (watched roots): new, renamed, or deleted skills
> reach the next catalog without a restart. There is no config file to edit.

## Activate a Skill

In DSH, skills are user- and model-invocable by default. Activate an agent by
its slash command or by name in conversation:

```
/agency-frontend-developer review this React component
```

or:

```
Use the agency-frontend-developer skill to review this component.
```

Available slugs follow the pattern `agency-<agent-name>`, e.g.:

- `agency-engineering-frontend-developer`
- `agency-engineering-backend-architect`
- `agency-specialized-reality-checker`
- `agency-marketing-growth-hacker`

## Regenerate

After modifying agents, regenerate the skill files:

```bash
./scripts/convert.sh --tool dsh
```

## File Format

Each skill is a `SKILL.md` file with the standard Agent-Skills frontmatter
(required `name` and `description`, strict kebab-case name) and the agent
persona as the body:

```markdown
---
name: 'agency-engineering-frontend-developer'
description: 'React/Vue/Angular、UI 実装、performance 改善を担当する日本向け frontend developer'
---
...agent body...
```

This is byte-identical to the Antigravity and Osaurus skill output
(`skill-md` format), so the Agency Agents app renders it natively.

## Skill Roots Scanned by DSH

| Priority | Source | Path |
|---|---|---|
| 100 | project | `<project>/.dsh/skills` |
| 200 | project | `<project>/.agents/skills` |
| 300 | custom | `customSkillDirs` config |
| 400 | user | `${DSH_HOME:-$HOME/.dsh}/skills` (default install) |
| 500 | user | `~/.agents/skills` |

Project skills (rank 100/200) shadow user skills (rank 400/500) of the same
name, so a project install overrides the user-wide one for that project.
