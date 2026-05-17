# superpowers-ja 連携

`agency-agents-ja` は日本の IT 開発現場向け role library です。`superpowers-ja` の `workflow-runner` と組み合わせると、要件定義、設計、QA、障害報告、RFP 回答のような複数職能の作業を順番に実行できます。

## 役割分担

| Repository | 役割 |
| --- | --- |
| `superpowers-ja` | workflow-runner、調査、review、document 作成などの作業方法 |
| `agency-agents-ja` | 日本の IT 開発、SIer、SaaS、業務部門向け専門 agent |

## Workflow

Machine-readable workflow は `workflows/` に置きます。

| Workflow | 用途 |
| --- | --- |
| `workflows/japanese-sier-requirements-review.yaml` | Backlog / Redmine / Jira ticket と仕様書の要件整理、設計、検収準備 |
| `workflows/ai-governance-rollout.yaml` | 社内 AI 利用 policy、prompt template、automation governance、研修、risk |
| `workflows/api-integration-delivery.yaml` | API 連携の要件整理、backend design、API test、技術 document |
| `workflows/b2b-saas-release.yaml` | B2B SaaS の release scope、QA、release note、CS 案内 |
| `workflows/b2b-lead-generation.yaml` | B2B lead generation の SEO、検索 / SNS 広告、webinar、営業 follow-up |
| `workflows/change-management-review.yaml` | 仕様変更、業務影響、承認、architecture impact、release 準備 |
| `workflows/customer-health-review.yaml` | 顧客 health、support analytics、account strategy、契約更新 risk |
| `workflows/enterprise-architecture-roadmap.yaml` | 全社 architecture、data governance、security、legacy modernization |
| `workflows/incident-report.yaml` | 障害時系列、security / privacy 確認、顧客向け障害報告書 |
| `workflows/japan-go-to-market-campaign.yaml` | 日本市場向け GTM、導入事例、developer community、SNS、partner、広告 |
| `workflows/kintone-business-app.yaml` | kintone 業務 app の要件整理、設計、検収準備 |
| `workflows/manufacturing-dx-assessment.yaml` | 製造業 DX、工場 IoT、品質管理の初期 assessment |
| `workflows/quality-governance-review.yaml` | 品質方針、QA gate、不具合傾向、release / 検収 risk |
| `workflows/rfp-response.yaml` | RFP 読解、提案 architecture、SLA / 保守観点、提案書 outline |
| `workflows/release-readiness-review.yaml` | Release 判定、作業手順、observability、privacy、検収 evidence |
| `workflows/revenue-governance-review.yaml` | RevOps、revenue data governance、内部監査、BCP / DR |
| `workflows/service-delivery-review.yaml` | SLA、問い合わせ、障害、service review、CS action |
| `workflows/technical-documentation-review.yaml` | 技術 document の改善、knowledge base 配置、引き継ぎ evidence |
| `workflows/vendor-cost-review.yaml` | Vendor 調達、risk、FinOps、pricing、契約単位 review |

## 使い方

AI coding tool から `superpowers-ja` の `workflow-runner` を指定し、この repository の workflow YAML を渡します。

```text
superpowers-ja の workflow-runner を使って agency-agents-ja/workflows/rfp-response.yaml を実行してください。
rfp は docs/rfp.md です。
```

```text
superpowers-ja の workflow-runner を使って agency-agents-ja/workflows/japanese-sier-requirements-review.yaml を実行してください。
ticket は PROJ-1234、spec は docs/spec.md です。
```

Workflow 内の `agents_dir` は `agency-agents-ja` repository root を前提にしています。別 directory から実行する場合は、tool 側で `agency-agents-ja` root を基準 directory として指定してください。

## 直接 agent を使う場合

Workflow を使わず、agent file を直接指定しても使えます。

```text
agency-agents-ja/engineering/engineering-japanese-requirements-engineer.md を使って、この仕様書の要件と受入条件を整理してください。
```

```text
agency-agents-ja/testing/testing-evidence-collector-ja.md を使って、この PR の検証 evidence を検収向けにまとめてください。
```

## メンテナンス

Workflow を追加したら、以下で role path と `depends_on` を確認します。
`examples/workflow-*.md` に workflow YAML を載せる場合は、実体の `workflows/*.yaml` と同期していることも検証されます。

```bash
npm run validate:workflows
npm run validate
```
