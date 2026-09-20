# CodeWhale Integration

CodeWhale uses generated `SKILL.md` directories.

```bash
./scripts/convert.sh --tool codewhale
./scripts/install.sh --tool codewhale
```

The default install destination is:

```text
~/.codewhale/skills/<agent-slug>/SKILL.md
```

Override it with `CODEWHALE_SKILLS_DIR=/path/to/skills`.
