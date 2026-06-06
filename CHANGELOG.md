# Changelog

All notable changes to `agency-agents-ja` are recorded here.

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
