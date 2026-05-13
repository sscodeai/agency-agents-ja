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
| `marketing/marketing-note-qiita-zenn-strategist.md` | note / Qiita / Zenn 技術広報 |
| `sales/sales-japanese-rfp-response-writer.md` | RFP、提案書、見積前提 |
| `support/support-japanese-incident-report-writer.md` | 障害報告書、postmortem |
| `specialized/japanese-public-sector-dx-consultant.md` | 自治体 DX、公共 sector |

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

## Roadmap

agent の設計方針と追加予定は [ROADMAP.md](ROADMAP.md) に記録します。

## License

MIT
