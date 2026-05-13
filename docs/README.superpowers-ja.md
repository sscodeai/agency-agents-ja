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
| `workflows/b2b-saas-release.yaml` | B2B SaaS の release scope、QA、release note、CS 案内 |
| `workflows/incident-report.yaml` | 障害時系列、security / privacy 確認、顧客向け障害報告書 |
| `workflows/kintone-business-app.yaml` | kintone 業務 app の要件整理、設計、検収準備 |
| `workflows/manufacturing-dx-assessment.yaml` | 製造業 DX、工場 IoT、品質管理の初期 assessment |
| `workflows/rfp-response.yaml` | RFP 読解、提案 architecture、SLA / 保守観点、提案書 outline |

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

```bash
npm run validate:workflows
npm run validate
```
