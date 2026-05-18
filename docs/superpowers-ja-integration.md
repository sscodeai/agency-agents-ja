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
| `workflows/japanese-sier-requirements-review.yaml` | SIer / 受託開発の要件、設計、検収準備 |
| `workflows/acceptance-readiness-review.yaml` | 検収条件、QA 結果、証跡、未解決事項、顧客承認の受入 readiness |
| `workflows/ai-governance-rollout.yaml` | 社内 AI 利用 policy、prompt、automation governance、training |
| `workflows/api-integration-delivery.yaml` | API 連携の要件、backend design、API test、document |
| `workflows/b2b-saas-release.yaml` | B2B SaaS release、QA、release note、CS |
| `workflows/b2b-lead-generation.yaml` | B2B lead generation、SEO、広告、webinar、営業 follow-up |
| `workflows/business-ui-readiness-review.yaml` | 業務画面、管理画面、form / table、accessibility、design system、frontend 実装 readiness |
| `workflows/change-management-review.yaml` | 仕様変更、影響分析、承認、release 準備 |
| `workflows/csv-data-migration-readiness.yaml` | CSV / Excel / Shift_JIS 取込、データ移行、DB 反映、検収 evidence |
| `workflows/customer-health-review.yaml` | 顧客 health、support analytics、account strategy、risk |
| `workflows/enterprise-architecture-roadmap.yaml` | 全社 architecture、data governance、security、legacy modernization |
| `workflows/incident-report.yaml` | 障害整理、security review、顧客向け報告 |
| `workflows/it-onboarding-offboarding.yaml` | 入退社、協力会社参画、権限、貸与品、研修、監査証跡の joiner / mover / leaver 管理 |
| `workflows/japan-go-to-market-campaign.yaml` | 日本市場 GTM、導入事例、community、SNS、partner、広告 |
| `workflows/kintone-business-app.yaml` | kintone 業務 app 設計 |
| `workflows/manufacturing-dx-assessment.yaml` | 製造業 DX / 工場 IoT assessment |
| `workflows/quality-governance-review.yaml` | 品質方針、QA gate、不具合傾向、検収 readiness |
| `workflows/rfp-response.yaml` | RFP 回答、提案、SLA / 保守観点 |
| `workflows/release-readiness-review.yaml` | release 判定、observability、privacy、検収 evidence |
| `workflows/revenue-governance-review.yaml` | RevOps、data governance、監査、BCP |
| `workflows/saas-contract-privacy-billing-review.yaml` | SaaS / 業務委託契約、個人情報、インボイス、電子帳簿保存法の導入前 review |
| `workflows/service-delivery-review.yaml` | SLA、問い合わせ、障害、service review、CS action |
| `workflows/technical-documentation-review.yaml` | 技術 document、knowledge base、引き継ぎ evidence |
| `workflows/vendor-cost-review.yaml` | vendor 調達、risk、FinOps、pricing、契約単位 |

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
Workflow table は `scripts/generate-workflow-table.js` で同期します。
`examples/workflow-*.md` に workflow YAML を載せる場合は、実体の `workflows/*.yaml` と同期していることも検証されます。

```bash
npm run validate:workflows
npm run validate
```
