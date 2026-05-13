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
| `engineering/engineering-japanese-backend-architect.md` | API、DB、batch、監査ログ |
| `engineering/engineering-japanese-frontend-engineer.md` | 業務画面、管理画面、form、table |
| `engineering/engineering-japanese-code-reviewer.md` | 日本語チーム向け code review |
| `engineering/engineering-japanese-security-engineer.md` | 認証認可、個人情報、security review |
| `engineering/engineering-japanese-sre.md` | SLO、監視、障害対応、runbook |
| `engineering/engineering-japanese-database-optimizer.md` | DB、query、index、migration |
| `engineering/engineering-japanese-legacy-modernization-engineer.md` | legacy system modernization |
| `engineering/engineering-japanese-performance-engineer.md` | response time、batch、DB、frontend 性能改善 |
| `engineering/engineering-kintone-developer.md` | Cybozu kintone 開発 |
| `engineering/engineering-line-works-integration-developer.md` | LINE WORKS 連携 |
| `project-management/project-management-japanese-pm.md` | WBS、課題、進捗、会議体 |
| `project-management/project-management-backlog-redmine-jira-steward.md` | ticket workflow 管理 |
| `project-management/project-management-acceptance-criteria-writer.md` | 受入条件、検収条件 |
| `testing/testing-japanese-qa-planner.md` | QA plan、test matrix |
| `testing/testing-evidence-collector-ja.md` | テスト証跡、CI 結果、検収資料 |
| `testing/testing-shift-jis-csv-tester.md` | Shift_JIS、CSV、Excel 検証 |
| `product/product-japanese-product-manager.md` | 日本市場向け product planning |
| `product/product-japanese-b2b-saas-planner.md` | B2B SaaS、契約、権限、CS |
| `legal/legal-japanese-privacy-compliance-reviewer.md` | 個人情報保護法、privacy review |
| `legal/legal-japanese-contract-reviewer.md` | 業務委託、NDA、SaaS 契約 review |
| `legal/legal-japanese-sla-maintenance-contract-reviewer.md` | SLA、保守契約、責任分界 |
| `marketing/marketing-note-qiita-zenn-strategist.md` | note / Qiita / Zenn 技術広報 |
| `marketing/marketing-line-official-account-operator.md` | LINE 公式アカウント運用 |
| `marketing/marketing-rakuten-amazon-japan-operator.md` | 楽天 / Amazon Japan EC 運用 |
| `marketing/marketing-yahoo-google-japan-seo.md` | Yahoo! JAPAN / Google SEO |
| `marketing/marketing-seminar-webinar-planner.md` | B2B セミナー / ウェビナー |
| `paid-media/paid-media-japan-search-social-strategist.md` | 日本向け検索広告 / SNS 広告 |
| `finance/finance-japanese-invoice-system-advisor.md` | インボイス制度、請求書 system |
| `finance/finance-electronic-bookkeeping-reviewer.md` | 電子帳簿保存法 review |
| `hr/hr-japanese-it-recruiter.md` | IT 採用、職務要件、面談設計 |
| `hr/hr-japanese-onboarding-specialist.md` | 新メンバー onboarding |
| `hr/hr-japanese-performance-review-facilitator.md` | IT 人事評価、1on1、昇格判断 |
| `design/design-japanese-business-ui-designer.md` | 日本の業務 UI / 管理画面 |
| `design/design-accessibility-auditor-ja.md` | 日本語 UI accessibility audit |
| `design/design-japanese-design-system-maintainer.md` | 業務 UI design system 運用 |
| `sales/sales-japanese-rfp-response-writer.md` | RFP、提案書、見積前提 |
| `support/support-japanese-incident-report-writer.md` | 障害報告書、postmortem |
| `support/support-japanese-customer-success-manager.md` | B2B SaaS customer success |
| `support/support-japanese-helpdesk-responder.md` | 日本語 helpdesk 一次対応 |
| `support/support-release-note-writer-ja.md` | 日本語 release note |
| `testing/testing-japanese-tool-evaluator.md` | SaaS / AI tool / 開発支援 tool 評価 |
| `specialized/japanese-public-sector-dx-consultant.md` | 自治体 DX、公共 sector |
| `specialized/specialized-japanese-manufacturing-dx-consultant.md` | 製造業 DX |
| `specialized/specialized-factory-iot-planner.md` | 工場 IoT plan |
| `specialized/specialized-quality-control-kaizen-advisor.md` | 品質管理、カイゼン |
| `specialized/specialized-japanese-knowledge-base-steward.md` | 社内 knowledge base / wiki 整備 |
| `supply-chain/supply-chain-japanese-vendor-evaluator.md` | vendor 評価、調達 |
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

| Workflow | 用途 |
| --- | --- |
| `workflows/japanese-sier-requirements-review.yaml` | SIer / 受託開発の要件、設計、検収準備 |
| `workflows/b2b-saas-release.yaml` | B2B SaaS release、QA、release note、CS |
| `workflows/b2b-lead-generation.yaml` | B2B lead generation、SEO、広告、webinar、営業 follow-up |
| `workflows/incident-report.yaml` | 障害整理、security review、顧客向け報告 |
| `workflows/kintone-business-app.yaml` | kintone 業務 app 設計 |
| `workflows/manufacturing-dx-assessment.yaml` | 製造業 DX / 工場 IoT assessment |
| `workflows/rfp-response.yaml` | RFP 回答、提案、SLA / 保守観点 |

### Agent を探す

[AGENT-LIST.md](AGENT-LIST.md) から用途に近い agent を探してください。一覧は `scripts/generate-agent-list.js` で自動生成します。

## メンテナンス

```bash
node scripts/generate-agent-list.js
node scripts/validate-workflows.js
scripts/validate.sh
```

CI では `scripts/validate.sh` を実行し、frontmatter、命名、禁止語、`AGENT-LIST.md` の同期、workflow の role path と依存関係を確認します。

## Roadmap

agent の設計方針と追加予定は [ROADMAP.md](ROADMAP.md) に記録します。

## License

MIT
