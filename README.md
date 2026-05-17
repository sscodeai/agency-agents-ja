# agency-agents-ja

日本の IT 開発、SIer、受託開発、自社サービス、SaaS、EC、製造業 DX の現場で使える AI 専門家エージェント集です。

既存の multi-agent role library で一般的な職能を参考にしながら、1 agent ずつ用途を見直し、日本の開発現場向けに再設計します。

## 方針

- 要件定義、基本設計、詳細設計、検収、保守運用まで扱う
- Backlog / Redmine / Jira、GitHub / GitLab / Bitbucket を前提にする
- 稟議、承認、議事録、エビデンス、個人情報、障害報告を軽視しない
- 丁寧なコミュニケーションと明確な判断基準を両立する
- 特定地域の platform 前提に寄せすぎず、日本の platform / 商習慣に合う agent を個別に設計する

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
| `engineering/engineering-japanese-sre.md` | SLO、監視、障害対応、runbook |
| `engineering/engineering-japanese-observability-engineer.md` | log、metrics、trace、dashboard、alert |
| `engineering/engineering-japanese-database-optimizer.md` | DB、query、index、migration |
| `engineering/engineering-japanese-legacy-modernization-engineer.md` | legacy system modernization |
| `engineering/engineering-japanese-mobile-app-builder.md` | iOS / Android / React Native / Flutter |
| `engineering/engineering-japanese-performance-engineer.md` | response time、batch、DB、frontend 性能改善 |
| `engineering/engineering-japanese-technical-writer.md` | 設計書、API document、運用手順 |
| `engineering/engineering-kintone-developer.md` | Cybozu kintone 開発 |
| `engineering/engineering-line-works-integration-developer.md` | LINE WORKS 連携 |
| `project-management/project-management-japanese-pm.md` | WBS、課題、進捗、会議体 |
| `project-management/project-management-japanese-business-analyst.md` | 業務分析、As-Is / To-Be、受入条件 |
| `project-management/project-management-backlog-redmine-jira-steward.md` | ticket workflow 管理 |
| `project-management/project-management-acceptance-criteria-writer.md` | 受入条件、検収条件 |
| `project-management/project-management-japanese-release-manager.md` | release 判定、作業手順、切り戻し |
| `project-management/project-management-japanese-change-management-lead.md` | 仕様変更、影響分析、承認、周知 |
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

workflow 内の `agents_dir` はこの repository root を基準にします。詳しい連携方法は [docs/README.superpowers-ja.md](docs/README.superpowers-ja.md) を参照してください。

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
| `workflows/change-management-review.yaml` | 仕様変更、影響分析、承認、release 準備 | `examples/workflow-change-management-review.md` |
| `workflows/csv-data-migration-readiness.yaml` | CSV / Excel / Shift_JIS 取込、データ移行、DB 反映、検収 evidence | `examples/workflow-csv-data-migration-readiness.md` |
| `workflows/customer-health-review.yaml` | 顧客 health、support analytics、account strategy、risk | `examples/workflow-customer-health-review.md` |
| `workflows/enterprise-architecture-roadmap.yaml` | 全社 architecture、data governance、security、legacy modernization | `examples/workflow-enterprise-architecture-roadmap.md` |
| `workflows/incident-report.yaml` | 障害整理、security review、顧客向け報告 | `examples/workflow-incident-report.md` |
| `workflows/japan-go-to-market-campaign.yaml` | 日本市場 GTM、導入事例、community、SNS、partner、広告 | `examples/workflow-japan-go-to-market-campaign.md` |
| `workflows/kintone-business-app.yaml` | kintone 業務 app 設計 | `examples/workflow-kintone-business-app.md` |
| `workflows/manufacturing-dx-assessment.yaml` | 製造業 DX / 工場 IoT assessment | `examples/workflow-manufacturing-dx-assessment.md` |
| `workflows/quality-governance-review.yaml` | 品質方針、QA gate、不具合傾向、検収 readiness | `examples/workflow-quality-governance-review.md` |
| `workflows/rfp-response.yaml` | RFP 回答、提案、SLA / 保守観点 | `examples/workflow-rfp-response.md` |
| `workflows/release-readiness-review.yaml` | release 判定、observability、privacy、検収 evidence | `examples/workflow-release-readiness-review.md` |
| `workflows/revenue-governance-review.yaml` | RevOps、data governance、監査、BCP | `examples/workflow-revenue-governance-review.md` |
| `workflows/service-delivery-review.yaml` | SLA、問い合わせ、障害、service review、CS action | `examples/workflow-service-delivery-review.md` |
| `workflows/technical-documentation-review.yaml` | 技術 document、knowledge base、引き継ぎ evidence | `examples/workflow-technical-documentation-review.md` |
| `workflows/vendor-cost-review.yaml` | vendor 調達、risk、FinOps、pricing、契約単位 | `examples/workflow-vendor-cost-review.md` |

### Agent を探す

[AGENT-LIST.md](AGENT-LIST.md) から用途に近い agent を探してください。一覧は `scripts/generate-agent-list.js` で自動生成します。

## メンテナンス

```bash
npm run generate
npm run validate:workflows
npm run validate
```

CI では `scripts/validate.sh` を実行し、frontmatter、命名、禁止語、`AGENT-LIST.md` の同期、workflow の role path と依存関係を確認します。
README と `docs/README.superpowers-ja.md` の workflow table は `scripts/generate-workflow-table.js` で同期します。
`examples/workflow-*.md` に YAML block を置く場合は、同名 workflow と内容が同期していることも確認します。

## Roadmap

agent の設計方針と追加予定は [ROADMAP.md](ROADMAP.md) に記録します。

## License

MIT
