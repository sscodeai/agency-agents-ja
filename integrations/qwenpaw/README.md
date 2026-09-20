# QwenPaw Integration

QwenPaw uses generated `SKILL.md` directories under a skill pool.

```bash
./scripts/convert.sh --tool qwenpaw
./scripts/install.sh --tool qwenpaw
```

The default install destination is:

```text
~/.qwenpaw/skill_pool/<agent-slug>/SKILL.md
```

Override it with `QWENPAW_SKILL_POOL=/path/to/skill_pool`.

Some QwenPaw setups keep imported skill-pool entries disabled until they are
enabled from the QwenPaw console. After installation, refresh or reopen the
QwenPaw session if the skills do not appear immediately.
