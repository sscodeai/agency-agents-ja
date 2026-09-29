# Changelog

All notable changes to `agency-agents-ja` are recorded here.

## Unreleased

- Fixed the Hermes installer, which printed `[OK] enabled plugin` while leaving `agency-agents-router` disabled or absent on real Hermes configs. The `plugins:` block now ends only at a top-level key (not a column-0 `# ====` banner), the `enabled:` sub-block is bounded at its first sibling, stale entries are swept out of `disabled:`, inline `[]` / `[a,b]` and trailing comments are handled, and uneditable shapes bail with a warning instead of reporting success. `scripts/check-hermes-config-rewrite.py` now runs 16 regression cases, including Hermes' own config shape.
- Added `evals/`, behaviour evaluation fixtures for the Japanese marketing search-growth agents, with `scripts/check-evals.js`, `npm run check:evals`, and validation wired into `scripts/validate.sh`. Fixtures follow the `SEARCH-GROWTH-STACK.md` evidence protocol.
- Added `.github/workflows/release.yml` so `v*` tags publish to npm through Trusted Publishing (OIDC, provenance) without a stored token.
- Fixed `release.yml`, which used a Markdown-style `>` comment block: YAML read it as a folded scalar, so the file never parsed, GitHub marked the workflow invalid, and every push to `main` produced a failed run with no logs. Added `scripts/check-github-workflows.js`, which parses every file under `.github/workflows/` and checks `name` / `on` / `jobs`, `runs-on`, and that each step has exactly one of `uses` or `run`. Wired into `scripts/validate.sh`, `npm run check:github-workflows`, and the maintenance tests.
- Added two Japan-original agents: 日本向け動画プロンプトエンジニア (`design/design-video-prompt-engineer.md`) and 日本向け鑑定・真贋評価アドバイザー (`specialized/specialized-authenticity-appraiser.md`).
- Deepened `specialized/healthcare-marketing-compliance.md` with pharma, medical device, OTC, health food, and Medical Advertising Guidelines applicability coverage instead of adding a duplicate healthcare marketing agent.
- Added the `Feature Request` issue template and corrected the division list in `new-agent-request.yml` to match `divisions.json`.
- Some of the subjects above were informed by the Chinese community edition `agency-agents-zh` (its evaluation fixtures, release automation, and agent coverage gaps). Nothing was copied: every file was rewritten for Japanese platforms, regulations, and delivery workflows.

## 0.4.0 - 2026-08-13

- Updated upstream coverage to `msitarzewski/agency-agents@ebe9c99` as of 2026-08-08.
- Expanded the catalog to 385 agents: 115 Japan-original and 270 upstream-aligned adapted agents.
- Added the `gis/` and `healthcare/` divisions, including GIS specialists, clinical evidence, healthcare innovation, and sovereign health systems agents.
- Added newly adapted upstream roles across engineering, security, legal, testing, game development, and specialized divisions, including Economy Designer, Privacy Engineer, LLM Post-Training Engineer, Data Visualization Engineer, UI Finish-Gate Reviewer, Rust Refactoring Specialist, RAG Pipeline Engineer, GaussDB Expert Engineer, and Japanese Timely Disclosure Reviewer.
- Added Codex, Osaurus, Hermes, Mistral Vibe, and ZCode integration support.
- Hardened release validation with generated integration checks, division/tool/runbook consistency checks, workflow YAML validation, package file checks, and a standard `npm test` script.
- Improved install and conversion tooling for selective installs, path overrides, deterministic generated outputs, and stale integration detection.
- Expanded README, integration docs, and contribution guidance for upstream parity, package publishing, and content boundary rules.

## 0.3.0 - 2026-06-06

- Updated upstream coverage to `msitarzewski/agency-agents@main` as of 2026-06-06.
- Added 25 newly covered upstream-aligned agents, raising upstream coverage from 184 to 209.
- Added the `security/` division with 10 adapted security agents for AppSec, cloud security, incident response, SecOps, detection engineering, and threat intelligence.
- Added Japan-original localized manufacturing and legacy security coverage, including an apparel factory planning agent.
- Expanded the catalog to 323 agents: 114 Japan-original and 209 upstream-aligned adapted agents.
- Added `security/` support to generation, validation, conversion, installation, and upstream parity tooling.
- Quoted hex color frontmatter values and added validation to keep frontmatter compatible with standard YAML parsers.

## 0.2.0 - 2026-05-26

- Completed Japanese market adaptation for all 184 upstream-aligned agents.
- Added Japan-original agents inspired by `agency-agents-zh`, including IoT, finance fraud, city tech, retail media, and travel operations roles.
- Expanded the catalog to 293 agents: 109 Japan-original and 184 upstream-aligned adapted agents.
- Added README acknowledgement for upstream `agency-agents` and Chinese `agency-agents-zh` inspirations.
- Added README stat synchronization tooling and SSCodeAI article links.
- Standardized the specialized technical translator agent naming.

## 0.1.0 - 2026-05-24

- Added 97 Japan-market original agents for SIer, SaaS, manufacturing DX, public sector, compliance, support, finance, HR, sales, and marketing workflows.
- Added 169 upstream-aligned skeleton agents mapped to `msitarzewski/agency-agents@main` as of 2026-05-24.
- Added 27 machine-readable workflows under `workflows/` with synchronized examples under `examples/`.
- Added `source`, `upstream_path`, `upstream_name`, and `translation_status` frontmatter conventions.
- Added generated catalogs for agent list, translation progress, and upstream coverage.
- Added validation for agent frontmatter, workflow role references, generated docs, and forbidden non-Japan localization drift.
