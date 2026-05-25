# Japanese (ja-JP) Localization Helpers

This directory contains optional helper data for localizing installed agent copies for Japanese-facing agent pickers.

The source files in this repository are already Japanese-oriented. These helpers are mainly for tools that install upstream-style agent copies and need Japanese `name` / `description` frontmatter values after installation.

## Files

| File | Description |
| --- | --- |
| `agent-names-ja.json` | Mapping of upstream English agent names to Japanese display names and descriptions |
| `localize-agents-ja.ps1` | PowerShell helper that updates installed `.md` agent files using the JSON mapping |

## Usage

After installing agents:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/i18n/localize-agents-ja.ps1
```

By default, the script processes:

- `%USERPROFILE%\.github\agents\`
- `%USERPROFILE%\.copilot\agents\`

Pass custom target directories if needed:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/i18n/localize-agents-ja.ps1 -TargetDirs @("C:\custom\path\agents")
```

## Notes

- This helper modifies installed copies, not source files.
- Re-run it after reinstalling agents if the target tool overwrites frontmatter.
- The JSON file is intentionally small and can be expanded as more upstream-aligned agents are fully translated.
