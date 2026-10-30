## Summary

<!-- What problem does this solve? What is the resulting behaviour? Link the issue. One PR, one concern. -->

- Change type: new agent / upstream sync / content fix / tool adaptation / docs
- Related issue:

## Agent information (when the PR adds or changes an agent)

- Name and path:
- Division:
- Source: `japan-original` / `upstream`
- Upstream file and fixed commit (for `source: upstream`):
- Difference from the closest existing agent, or why this changes:

## Contribution rules

<!-- Tick only what applies; write "n/a" rather than widening the diff to tick a box. -->

- [ ] Read [CONTRIBUTING.md](../CONTRIBUTING.md) (or [CONTRIBUTING_ja-JP.md](../CONTRIBUTING_ja-JP.md)). The agent is not tied to a specific employer and contains no promotion.
- [ ] The agent body contains no vendor account setup, plugin install, or tool-specific command recipes.
- [ ] Frontmatter has `name`, `description`, `emoji`, `color`, and `source` (plus `upstream_path` / `translation_status` for upstream agents).
- [ ] New / removed / renamed agents are reflected in `AGENT-LIST.md`, `README.md` counts, `TRANSLATION-PROGRESS.md`, and `UPSTREAM-COVERAGE.md` (run `npm run generate`).
- [ ] Tool or converter changes were checked against the affected convert / install paths; no unverified platform is claimed.
- [ ] Japanese wording, code comments, docstrings, internal links, and fenced code blocks were checked.

## Verification

<!-- Record the commands you actually ran and their result. "Not run" plus a reason is better than an unchecked box. -->

| Check | Command or method | Result / evidence |
| --- | --- | --- |
| Catalog and generated docs | `npm run validate` | |
| Changed agent structure | `bash scripts/lint-agents.sh <path>` | |
| Evaluation fixtures (when affected) | `npm run check:evals` | |
| Package contents (when agents or packaging change) | `npm run check:package` | |
| Tool adaptation / real scenario | platform, format, reproduction steps | |

## Limitations and compatibility

<!-- Version constraints, untested environments, migration impact, known limitations. Write "none" if there are none. -->
