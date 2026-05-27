# agency-agents-ja

**Language**: [English](#english) | [日本語](#日本語)

---

## English

Japanese community edition of [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents).

A library of AI specialist agents and workflows for Japanese IT delivery: SIer (system integrator) work, custom development, in-house SaaS, EC, manufacturing DX, and public-sector projects. It preserves upstream agent paths for compatibility while adding Japan-market originals for SIer, SaaS, manufacturing DX, and public-sector workflows.

### Stats

| Metric | Count |
| --- | --- |
| Total agents | 281 |
| ⭐ Japan-market originals | 97 |
| Upstream-aligned (adapted to Japan) | 184 / 184 |
| Upstream skeleton backlog | 0 |
| Workflows (`workflows/`) | 27 |
| Categories | 17 |
| Upstream baseline | `msitarzewski/agency-agents@main` as of 2026-05-24 |

The `source:` frontmatter field on every agent file marks whether it is `japan-original` (independently designed for the Japanese market) or `upstream` (derived from the upstream agent inventory; see [Translation status](#translation-status) below). [AGENT-LIST.md](AGENT-LIST.md) renders ⭐ for Japan originals.

Maintenance references:
- [TRANSLATION-PROGRESS.md](TRANSLATION-PROGRESS.md) tracks adapted / translated / skeleton counts.
- [UPSTREAM-COVERAGE.md](UPSTREAM-COVERAGE.md) checks local frontmatter coverage.
- [docs/localization-review-checklist-ja.md](docs/localization-review-checklist-ja.md) defines the Japanese `adapted` quality bar.
- The scheduled `Upstream Parity` workflow compares this repo against upstream `main` and flags new upstream agent paths.

### What is Japan-specific here

The 97 ⭐ Japan-market originals cover scenarios upstream does not address:

- **SIer / 受託開発**: requirements engineering, basic/detailed design, acceptance review (検収), change management, release sign-off, RFP response
- **Compliance**: 個人情報保護法 (APPI), インボイス制度 (invoice system), 電子帳簿保存法 (electronic bookkeeping), AI usage policy
- **Japanese platforms**: kintone, LINE WORKS, Backlog / Redmine / Jira, Rakuten / Amazon Japan, note / Qiita / Zenn, Yahoo! JAPAN SEO, LINE Official Account
- **Manufacturing DX / public sector**: 工場 IoT, 自治体 DX, BCP, 内部統制
- **Workflows**: 27 end-to-end workflows that chain agents together (e.g. `japanese-sier-requirements-review`, `acceptance-readiness-review`, `csv-data-migration-readiness`, `oss-localization-launch`, `oss-upstream-sync`)

### Translation status

The 184 `source: upstream` agents are currently `translation_status: adapted` — derived from the upstream agent inventory but **rewritten** for the Japanese market rather than translated literally. Each one has a Japanese-language `description`, `役割`, `想定シーン`, and `必ず確認すること` tuned to SIer / SaaS / 受託 / 製造業 DX / 公共 sector contexts, plus the `upstream_path:` frontmatter pointing back to the upstream original for compatibility and audit.

We deliberately chose "adapted" over "literal translation":
- Literal translation of every upstream English prompt would be slower to produce and less useful for Japanese teams (English-centric examples, US-centric platforms, no 稟議/検収 framing).
- Adapted agents preserve the role-level intent (e.g. "Backend Architect") while replacing examples and workflow framing with Japanese equivalents.
- The upstream English prompt remains the source of truth for `role-level intent`; this repo is the source of truth for `Japanese-market execution`.

When upstream `main` adds or revises an agent, we treat that as an adaptation task in this repo. `translation_status` will move to `translated` only if we ever produce a literal translation in addition to the adaptation.

You can query the breakdown directly:

```bash
AGENT_DIRS="academic engineering project-management testing product marketing paid-media finance game-development hr design legal sales spatial-computing support supply-chain specialized"

# Adapted (rewritten for Japan): currently 184
grep -rl '^translation_status: adapted'    $AGENT_DIRS | wc -l

# Literal translation of upstream prompt: currently 0
grep -rl '^translation_status: translated' $AGENT_DIRS | wc -l

# Untouched Japan-context placeholders: currently 0
grep -rl '^translation_status: skeleton'   $AGENT_DIRS | wc -l
```

For ongoing maintenance, run:

```bash
npm run generate
npm run validate
npm run check:upstream-parity
```

### Frontmatter schema

Every agent file has this frontmatter:

| Field | Required | Notes |
| --- | --- | --- |
| `name` | yes | Display name (Japanese) |
| `description` | yes | One-line summary |
| `emoji` | yes | Display metadata |
| `color` | yes | Display metadata |
| `source` | yes | `japan-original` or `upstream` |
| `upstream_path` | when `source: upstream` | Path of the corresponding file in [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) |
| `upstream_name` | optional | Original English name. Useful when the Japanese `name` diverges from the upstream concept (e.g. the upstream `Douyin Strategist` is repurposed as a Japan-market `TikTok Japan 戦略家` here). |
| `translation_status` | when `source: upstream` | `adapted` = role rewritten for Japanese market (most upstream agents in this repo). `translated` = literal translation of upstream prompt. `skeleton` = Japan-context placeholder, upstream prompt not yet translated or adapted. Absent on `japan-original`. |

`scripts/validate.sh` enforces all required fields, value constraints, and disallows `[upstream]`-prefixed `name` values (use the schema fields above instead).

### Quick start

Point any agent file at your AI coding tool:

```text
Use engineering/engineering-japanese-requirements-engineer.md to extract requirements
and acceptance criteria from this Backlog ticket.
```

Or run a multi-agent workflow via [`superpowers-ja`](docs/superpowers-ja-integration.md):

```text
Use superpowers-ja workflow-runner to execute
agency-agents-ja/workflows/japanese-sier-requirements-review.yaml.
ticket: PROJ-1234, spec: docs/spec.md
```

### Upstream framework docs (not yet localized)

In addition to agent files, this repo mirrors two upstream documentation directories verbatim in English:

- [`strategy/`](strategy/) — upstream's executive brief, playbooks, runbooks, coordination templates (16 files)
- [`integrations/`](integrations/) — upstream's integration guides for Claude Code, Cursor, Gemini CLI, GitHub Copilot, MCP memory, etc. (14 files)

These are **not** in scope of `scripts/validate.sh` (the agent CI) and **do not** carry `source:` frontmatter. They are kept in English at upstream parity so the two repos can be synced cleanly. Japanese-language adaptation of these framework docs is on the roadmap but not in this release.

### Acknowledgments

This repository is derived from [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) (MIT licensed). All upstream agent paths are preserved 1:1 under their original directories so the two repos can be compared file-by-file. We thank the upstream maintainers and contributors.

### License

MIT

---

## 日本語

日本の IT 開発、SIer、受託開発、自社サービス、SaaS、EC、製造業 DX の現場で使える AI 専門家エージェント集です。

英文上流 [agency-agents](https://github.com/msitarzewski/agency-agents) の汎用 agent を日本語化・日本市場向けに移植・適配しつつ、SIer、受託開発、日本 SaaS、製造業 DX、公共 sector で使うための日本特化 agent も追加しています。

## 方針

- 要件定義、基本設計、詳細設計、検収、保守運用まで扱う
- Backlog / Redmine / Jira、GitHub / GitLab / Bitbucket を前提にする
- 稟議、承認、議事録、エビデンス、個人情報、障害報告を軽視しない
- 丁寧なコミュニケーションと明確な判断基準を両立する
- 特定地域の platform 前提に寄せすぎず、日本の platform / 商習慣に合う agent を個別に設計する
- 上流と同じ path の agent は coverage と追従性を重視し、日本特化 agent は現場 workflow での使いやすさを重視する

## Coverage

- 日本特化 agent (⭐ `source: japan-original`): 97（日本の IT 開発、SIer、SaaS、EC、製造業 DX、公共 sector 向け）
- 上流由来 agent (`source: upstream`): 184（2026-05-24 時点の英文上流 `main` の agent path に対応。現在は `translation_status: adapted` ＝ 上流 role を日本市場向けに書き直し済み。`upstream_path:` で 1:1 対応関係を保持）
- 上流由来 agent の skeleton backlog: 0
- 合計: 281 agents
- Workflow: 27

完全な一覧は [AGENT-LIST.md](AGENT-LIST.md) を参照してください（⭐ が日本特化 agent）。
翻訳進捗は [TRANSLATION-PROGRESS.md](TRANSLATION-PROGRESS.md)、上流 path coverage は [UPSTREAM-COVERAGE.md](UPSTREAM-COVERAGE.md) で確認できます。
`adapted` の品質基準は [docs/localization-review-checklist-ja.md](docs/localization-review-checklist-ja.md) を参照してください。

## 初期 Agent

| Agent | 用途 |
| --- | --- |
| `engineering/engineering-japanese-requirements-engineer.md` | 要件定義、受入条件、仕様確認 |
| `engineering/engineering-japanese-sier-architect.md` | SIer / 受託開発向け architecture |
| `engineering/engineering-japanese-enterprise-architect.md` | 全社 system、data、integration、governance、移行 roadmap |
| `engineering/engineering-japanese-backend-architect.md` | API、DB、batch、監査ログ |
| `engineering/engineering-japanese-data-engineer.md` | ETL / ELT、DWH、BI、CSV、data quality |
| `engineering/engineering-japanese-data-governance-steward.md` | data owner、catalog、品質、権限、監査 |
| `engineering/engineering-japanese-frontend-engineer.md` | 業務画面、管理画面、form、table |
| `engineering/engineering-japanese-code-reviewer.md` | 日本語チーム向け code review |
| `engineering/engineering-japanese-security-engineer.md` | 認証認可、個人情報、security review |
| `engineering/engineering-japanese-software-supply-chain-engineer.md` | npm / PyPI / OSS license / CVE / SBOM / provenance / 委託先承認 |
| `engineering/engineering-japanese-sre.md` | SLO、監視、障害対応、runbook |
| `engineering/engineering-japanese-observability-engineer.md` | log、metrics、trace、dashboard、alert |
| `engineering/engineering-japanese-database-optimizer.md` | DB、query、index、migration |
| `engineering/engineering-japanese-legacy-modernization-engineer.md` | legacy system modernization |
| `engineering/engineering-japanese-mobile-app-builder.md` | iOS / Android / React Native / Flutter |
| `engineering/engineering-japanese-performance-engineer.md` | response time、batch、DB、frontend 性能改善 |
| `engineering/engineering-japanese-technical-writer.md` | 設計書、API document、運用手順 |
| `engineering/engineering-japanese-oss-localization-engineer.md` | OSS の README / docs / CONTRIBUTING / CLI message 自然な日本語化、upstream 追従 |
| `engineering/engineering-kintone-developer.md` | Cybozu kintone 開発 |
| `engineering/engineering-line-works-integration-developer.md` | LINE WORKS 連携 |
| `project-management/project-management-japanese-pm.md` | WBS、課題、進捗、会議体 |
| `project-management/project-management-japanese-business-analyst.md` | 業務分析、As-Is / To-Be、受入条件 |
| `project-management/project-management-backlog-redmine-jira-steward.md` | ticket workflow 管理 |
| `project-management/project-management-acceptance-criteria-writer.md` | 受入条件、検収条件 |
| `project-management/project-management-japanese-release-manager.md` | release 判定、作業手順、切り戻し |
| `project-management/project-management-japanese-change-management-lead.md` | 仕様変更、影響分析、承認、周知 |
| `project-management/project-management-japanese-upstream-sync-coordinator.md` | 上流 OSS の更新を watch、fork 追従、翻訳追従、追従 PR / ticket 化 |
| `testing/testing-japanese-qa-planner.md` | QA plan、test matrix |
| `testing/testing-japanese-quality-assurance-manager.md` | 品質方針、QA gate、不具合傾向、検収 readiness |
| `testing/testing-japanese-api-tester.md` | API contract、異常系、権限、検収 evidence |
| `testing/testing-evidence-collector-ja.md` | テスト証跡、CI 結果、検収資料 |
| `testing/testing-shift-jis-csv-tester.md` | Shift_JIS、CSV、Excel 検証 |
| `product/product-japanese-product-manager.md` | 日本市場向け product planning |
| `product/product-japanese-b2b-saas-planner.md` | B2B SaaS、契約、権限、CS |
| `legal/legal-japanese-privacy-compliance-reviewer.md` | 個人情報保護法、privacy review |
| `legal/legal-japanese-ai-policy-writer.md` | 生成 AI / AI tool 利用 policy |
| `legal/legal-japanese-contract-reviewer.md` | 業務委託、NDA、SaaS 契約 review |
| `legal/legal-japanese-policy-writer.md` | IT / security / SaaS 利用社内 policy |
| `legal/legal-japanese-sla-maintenance-contract-reviewer.md` | SLA、保守契約、責任分界 |
| `legal/legal-japanese-data-privacy-officer.md` | 個人情報、委託先、保存期間、漏えい対応 |
| `marketing/marketing-note-qiita-zenn-strategist.md` | note / Qiita / Zenn 技術広報 |
| `marketing/marketing-japanese-oss-positioning-writer.md` | 上流 OSS の README / docs を日本市場向けに positioning し直す |
| `marketing/marketing-japanese-ai-citation-strategist.md` | 生成 AI / answer engine での引用・推薦可視性、AEO / GEO 改善 |
| `marketing/marketing-japanese-developer-advocate.md` | API / SDK / OSS developer advocacy |
| `marketing/marketing-japanese-product-marketing-manager.md` | positioning、message、launch、sales enablement |
| `marketing/marketing-japanese-market-researcher.md` | 市場規模、競合、顧客課題、購買 process |
| `marketing/marketing-japanese-case-study-writer.md` | 導入事例、顧客 proof、公開許諾 |
| `marketing/marketing-japanese-community-manager.md` | user group、developer community、feedback loop |
| `marketing/marketing-japanese-customer-marketing-manager.md` | 既存顧客 marketing、advocacy、user group |
| `marketing/marketing-instagram-lemon8-operator.md` | Instagram / Lemon8 採用広報、event、事例 |
| `marketing/marketing-tiktok-japan-strategist.md` | TikTok / short video strategy |
| `marketing/marketing-line-official-account-operator.md` | LINE 公式アカウント運用 |
| `marketing/marketing-rakuten-amazon-japan-operator.md` | 楽天 / Amazon Japan EC 運用 |
| `marketing/marketing-yahoo-google-japan-seo.md` | Yahoo! JAPAN / Google SEO |
| `marketing/marketing-seminar-webinar-planner.md` | B2B セミナー / ウェビナー |
| `marketing/marketing-japanese-knowledge-commerce-strategist.md` | 有料 newsletter、講座、template、community |
| `paid-media/paid-media-japan-search-social-strategist.md` | 日本向け検索広告 / SNS 広告 |
| `finance/finance-japanese-invoice-system-advisor.md` | インボイス制度、請求書 system |
| `finance/finance-electronic-bookkeeping-reviewer.md` | 電子帳簿保存法 review |
| `finance/finance-japanese-finops-analyst.md` | cloud / SaaS cost、予算、配賦、削減施策 |
| `finance/finance-japanese-internal-audit-coordinator.md` | IT 統制、権限、変更、証跡、監査対応 |
| `hr/hr-japanese-it-recruiter.md` | IT 採用、職務要件、面談設計 |
| `hr/hr-japanese-onboarding-specialist.md` | 新メンバー onboarding |
| `hr/hr-japanese-performance-review-facilitator.md` | IT 人事評価、1on1、昇格判断 |
| `hr/hr-japanese-corporate-training-designer.md` | security、AI 活用、開発 process 研修 |
| `design/design-japanese-business-ui-designer.md` | 日本の業務 UI / 管理画面 |
| `design/design-accessibility-auditor-ja.md` | 日本語 UI accessibility audit |
| `design/design-japanese-design-system-maintainer.md` | 業務 UI design system 運用 |
| `sales/sales-japanese-rfp-response-writer.md` | RFP、提案書、見積前提 |
| `sales/sales-japanese-account-strategist.md` | 既存顧客 account plan、更新、拡張提案 |
| `sales/sales-japanese-partner-alliance-manager.md` | partner alliance、co-marketing、共同提案 |
| `sales/sales-japanese-sales-operations-analyst.md` | pipeline、forecast、CRM hygiene、営業 KPI |
| `sales/sales-japanese-revenue-operations-manager.md` | funnel、契約、請求、更新、拡張 process |
| `sales/sales-japanese-sales-engineer.md` | 技術商談、demo、PoC、feasibility |
| `support/support-japanese-incident-report-writer.md` | 障害報告書、postmortem |
| `support/support-japanese-customer-success-manager.md` | B2B SaaS customer success |
| `support/support-japanese-helpdesk-responder.md` | 日本語 helpdesk 一次対応 |
| `support/support-japanese-it-asset-manager.md` | PC、SaaS license、account、貸与品管理 |
| `support/support-release-note-writer-ja.md` | 日本語 release note |
| `support/support-japanese-support-analytics-reporter.md` | 問い合わせ、SLA、FAQ、顧客影響分析 |
| `support/support-japanese-service-delivery-manager.md` | SLA、問い合わせ、障害、顧客報告、改善計画 |
| `testing/testing-japanese-tool-evaluator.md` | SaaS / AI tool / 開発支援 tool 評価 |
| `specialized/japanese-public-sector-dx-consultant.md` | 自治体 DX、公共 sector |
| `specialized/specialized-japanese-automation-governance-architect.md` | RPA、AI agent、automation governance |
| `specialized/specialized-japanese-manufacturing-dx-consultant.md` | 製造業 DX |
| `specialized/specialized-factory-iot-planner.md` | 工場 IoT plan |
| `specialized/specialized-quality-control-kaizen-advisor.md` | 品質管理、カイゼン |
| `specialized/specialized-japanese-knowledge-base-steward.md` | 社内 knowledge base / wiki 整備 |
| `specialized/specialized-japanese-meeting-assistant.md` | 議事録、決定事項、課題、次 action |
| `specialized/specialized-japanese-prompt-engineer.md` | 社内 AI 活用 prompt、評価、guardrail |
| `specialized/specialized-japanese-risk-assessor.md` | project、release、AI 活用 risk assessment |
| `specialized/specialized-japanese-pricing-strategist.md` | pricing、packaging、見積前提、値引き rule |
| `specialized/specialized-japanese-business-continuity-planner.md` | BCP、DR、代替運用、連絡網、訓練 |
| `supply-chain/supply-chain-japanese-vendor-evaluator.md` | vendor 評価、調達 |
| `supply-chain/supply-chain-japanese-procurement-manager.md` | SaaS、cloud、委託、hardware 調達 |
| `supply-chain/supply-chain-japanese-vendor-risk-manager.md` | vendor security、privacy、BCP、契約 risk |
| `supply-chain/supply-chain-inventory-forecasting-ja.md` | 在庫予測、安全在庫 |

## Agent 形式

```markdown
---
name: 日本語名
description: 呼び出す場面、専門性、成果物
emoji: 🧩
color: blue
source: japan-original    # または upstream
# upstream_path: <dir>/<base>.md         # source: upstream のときに必須
# upstream_name: Original English Name   # source: upstream のとき推奨
# translation_status: adapted            # adapted | translated | skeleton
---

# 日本語名

## 役割
## 想定シーン
## 必ず確認すること
## 作業手順
## 成果物
## 日本の現場での注意点
## 出力フォーマット
```

## 使い方

### 直接指定

AI coding tool に agent file を指定して読み込ませます。

```text
engineering/engineering-japanese-requirements-engineer.md を使って、この Backlog ticket の要件と受入条件を整理してください。
```

```text
testing/testing-evidence-collector-ja.md を使って、この PR の検証 evidence をまとめてください。
```

### superpowers-ja workflow-runner と使う

`superpowers-ja` の `workflow-runner` skill は YAML workflow を読み、複数 role を順番に実行できます。

例:

```text
superpowers-ja の workflow-runner を使って agency-agents-ja/workflows/japanese-sier-requirements-review.yaml を実行してください。
ticket は PROJ-1234、spec は docs/spec.md です。
```

workflow 内の `agents_dir` はこの repository root を基準にします。詳しい連携方法は [docs/superpowers-ja-integration.md](docs/superpowers-ja-integration.md) を参照してください。

### Workflow YAML

`workflows/` には `superpowers-ja` から直接使える machine-readable workflow を置いています。
`examples/` には主要 workflow の読みやすい例を置いています。

| Workflow | 用途 | Example |
| --- | --- | --- |
| `workflows/japanese-sier-requirements-review.yaml` | SIer / 受託開発の要件、設計、検収準備 | `examples/workflow-japanese-sier-requirements.md` |
| `workflows/acceptance-readiness-review.yaml` | 検収条件、QA 結果、証跡、未解決事項、顧客承認の受入 readiness | `examples/workflow-acceptance-readiness-review.md` |
| `workflows/ai-governance-rollout.yaml` | 社内 AI 利用 policy、prompt、automation governance、training | `examples/workflow-ai-governance-rollout.md` |
| `workflows/api-integration-delivery.yaml` | API 連携の要件、backend design、API test、document | `examples/workflow-api-integration-delivery.md` |
| `workflows/b2b-saas-release.yaml` | B2B SaaS release、QA、release note、CS | `examples/workflow-b2b-saas-release.md` |
| `workflows/b2b-lead-generation.yaml` | B2B lead generation、SEO、広告、webinar、営業 follow-up | `examples/workflow-b2b-lead-generation.md` |
| `workflows/business-ui-readiness-review.yaml` | 業務画面、管理画面、form / table、accessibility、design system、frontend 実装 readiness | `examples/workflow-business-ui-readiness-review.md` |
| `workflows/change-management-review.yaml` | 仕様変更、影響分析、承認、release 準備 | `examples/workflow-change-management-review.md` |
| `workflows/csv-data-migration-readiness.yaml` | CSV / Excel / Shift_JIS 取込、データ移行、DB 反映、検収 evidence | `examples/workflow-csv-data-migration-readiness.md` |
| `workflows/customer-health-review.yaml` | 顧客 health、support analytics、account strategy、risk | `examples/workflow-customer-health-review.md` |
| `workflows/enterprise-architecture-roadmap.yaml` | 全社 architecture、data governance、security、legacy modernization | `examples/workflow-enterprise-architecture-roadmap.md` |
| `workflows/incident-report.yaml` | 障害整理、security review、顧客向け報告 | `examples/workflow-incident-report.md` |
| `workflows/it-onboarding-offboarding.yaml` | 入退社、協力会社参画、権限、貸与品、研修、監査証跡の joiner / mover / leaver 管理 | `examples/workflow-it-onboarding-offboarding.md` |
| `workflows/japan-go-to-market-campaign.yaml` | 日本市場 GTM、導入事例、community、SNS、partner、広告 | `examples/workflow-japan-go-to-market-campaign.md` |
| `workflows/kintone-business-app.yaml` | kintone 業務 app 設計 | `examples/workflow-kintone-business-app.md` |
| `workflows/manufacturing-dx-assessment.yaml` | 製造業 DX / 工場 IoT assessment | `examples/workflow-manufacturing-dx-assessment.md` |
| `workflows/quality-governance-review.yaml` | 品質方針、QA gate、不具合傾向、検収 readiness | `examples/workflow-quality-governance-review.md` |
| `workflows/rfp-response.yaml` | RFP 回答、提案、SLA / 保守観点 | `examples/workflow-rfp-response.md` |
| `workflows/release-readiness-review.yaml` | release 判定、observability、privacy、検収 evidence | `examples/workflow-release-readiness-review.md` |
| `workflows/revenue-governance-review.yaml` | RevOps、data governance、監査、BCP | `examples/workflow-revenue-governance-review.md` |
| `workflows/saas-contract-privacy-billing-review.yaml` | SaaS / 業務委託契約、個人情報、インボイス、電子帳簿保存法の導入前 review | `examples/workflow-saas-contract-privacy-billing-review.md` |
| `workflows/service-delivery-review.yaml` | SLA、問い合わせ、障害、service review、CS action | `examples/workflow-service-delivery-review.md` |
| `workflows/technical-documentation-review.yaml` | 技術 document、knowledge base、引き継ぎ evidence | `examples/workflow-technical-documentation-review.md` |
| `workflows/vendor-cost-review.yaml` | vendor 調達、risk、FinOps、pricing、契約単位 | `examples/workflow-vendor-cost-review.md` |
| `workflows/oss-localization-launch.yaml` | 上流 OSS project を日本市場向けに初回ローカライズして公開するための workflow。翻訳、用語集、positioning、license / 商標確認、公開 plan、Backlog / Redmine / Jira ticket、初週 KPI までを日本 IT 現場向けに整える | `examples/workflow-oss-localization-launch.md` |
| `workflows/oss-upstream-sync.yaml` | fork 後の OSS project を継続的に上流追従するための workflow。upstream release / commit の分類、fork 独自改修との衝突確認、翻訳追従、release note への反映、Backlog / Redmine / Jira ticket 化、四半期 sync 健全性 review までを日本 IT 現場向けに整える | `examples/workflow-oss-upstream-sync.md` |
| `workflows/software-supply-chain-review.yaml` | npm / PyPI / Maven などソフトウェア依存、OSS license、CVE、SBOM、provenance、委託先承認、incident readiness を日本 IT 現場向けに review | `examples/workflow-software-supply-chain-review.md` |

### Agent を探す

[AGENT-LIST.md](AGENT-LIST.md) から用途に近い agent を探してください。一覧は `scripts/generate-agent-list.js` で自動生成します。

## 上流との関係

- 184 個の `source: upstream` agent は、上流 [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) (MIT) の各 agent path に 1:1 で対応します。現在は `translation_status: adapted`（直訳ではなく、日本市場向けに役割を書き直し済み）。frontmatter の `upstream_path:` で 1:1 対応関係を保持
- 97 個の `source: japan-original` agent は、上流に対応する agent がない、日本市場向けに独自設計した agent です（AGENT-LIST.md で ⭐ で識別）
- 上流の framework 文書（[`strategy/`](strategy/) 16 ファイル、[`integrations/`](integrations/) 14 ファイル）は現状そのまま英語で保持しています。これらは `source:` frontmatter を持たず、`scripts/validate.sh` の対象外です。日本語化は roadmap 上の項目です
- 上流 `main` への追従と本翻訳の方針は [ROADMAP.md](ROADMAP.md) を参照してください

### Frontmatter schema

| Field | 必須 | 内容 |
| --- | --- | --- |
| `name` | yes | 表示名（日本語） |
| `description` | yes | 1 行概要 |
| `emoji` / `color` | yes | 表示用 |
| `source` | yes | `japan-original` か `upstream` |
| `upstream_path` | `source: upstream` のとき必須 | 上流 [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) 内の対応 file path |
| `upstream_name` | optional | 上流 agent の英語名。日本市場向けに `name` が乖離した場合に保持（例：上流 `Douyin Strategist` → ja `TikTok Japan 戦略家`） |
| `translation_status` | `source: upstream` のとき必須 | `adapted`（上流 role を日本市場向けに書き直し済み。本 repo の標準）／`translated`（上流 prompt の直訳）／`skeleton`（未着手の placeholder）。`japan-original` には付けない |

翻訳進捗の確認:

```bash
grep -rl '^translation_status: adapted'    . | wc -l  # 適応済み (日本市場向けに書き直し)
grep -rl '^translation_status: translated' . | wc -l  # 直訳
grep -rl '^translation_status: skeleton'   . | wc -l  # 未着手 placeholder
```

## メンテナンス

```bash
npm run generate
npm run generate:translation-progress
npm run check:upstream-coverage
npm run validate:workflows
npm run validate
```

CI では `scripts/validate.sh` を実行し、frontmatter（`name`、`description`、`emoji`、`color`、`source`、`source: upstream` のときは `upstream_path` と `translation_status` も必須）、命名、禁止語、`AGENT-LIST.md` / `TRANSLATION-PROGRESS.md` / `UPSTREAM-COVERAGE.md` の同期、workflow の role path と依存関係を確認します。
README と `docs/superpowers-ja-integration.md` の workflow table は `scripts/generate-workflow-table.js` で同期します。
`examples/workflow-*.md` に YAML block を置く場合は、同名 workflow と内容が同期していることも確認します。

## Roadmap

agent の設計方針と追加予定は [ROADMAP.md](ROADMAP.md) に記録します。

## License

MIT
