# Codex Integration

Converts all `agency-agents-ja` agents into Codex custom agent TOML files.
Each source agent becomes one standalone `.toml` file containing:

- `name`
- `description`
- `developer_instructions`

## Install

```bash
./scripts/convert.sh --tool codex
./scripts/install.sh --tool codex
```

This copies generated agent files to `~/.codex/agents/`.

## Regenerate

```bash
./scripts/convert.sh --tool codex
```
