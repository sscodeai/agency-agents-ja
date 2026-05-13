# Agent Design Roadmap

agency-agents-ja の agent 設計ロードマップです。

既存の multi-agent role library で一般的な職能を参考にしつつ、日本の IT 開発現場で実際に使える role と成果物へ再設計します。この文書は外部リポジトリからの機械的な移植表ではなく、agent を追加・調整するための設計メモです。

## 方針

- 1 agent ずつ用途、呼び出し場面、成果物を確認する
- 日本の SIer、受託開発、自社サービス、SaaS、EC、製造業 DX で使える形にする
- 要件定義、基本設計、詳細設計、検収、保守運用、障害対応まで扱う
- Backlog / Redmine / Jira、GitHub / GitLab / Bitbucket、Slack / Teams / LINE WORKS、kintone を自然に扱う
- 稟議、承認、議事録、エビデンス、個人情報、監査ログを軽視しない

## Phase 1: Core IT Delivery

| Reference Role | Japanese Agent | 方針 |
| --- | --- | --- |
| Project Manager | `project-management/project-management-japanese-pm.md` | 日本の WBS、課題管理、進捗会議、議事録、検収へ再設計 |
| Software Architect | `engineering/engineering-japanese-sier-architect.md` | SIer / 受託開発の基本設計、詳細設計、非機能、移行へ特化 |
| Code Reviewer | `engineering/engineering-japanese-code-reviewer.md` | 日本語レビュー、重大度、証跡、承認条件へ調整 |
| Requirements Engineer | `engineering/engineering-japanese-requirements-engineer.md` | 要件定義、受入条件、仕様確認へ特化 |
| Test Evidence Collector | `testing/testing-evidence-collector-ja.md` | テスト証跡、検収、CI、スクリーンショット整理へ日本化 |
| Collaboration Integration Engineer | `engineering/engineering-line-works-integration-developer.md` | LINE WORKS 連携へ特化 |
| Business App Developer | `engineering/engineering-kintone-developer.md` | kintone 業務アプリ開発へ特化 |
| Privacy / Compliance Reviewer | `legal/legal-japanese-privacy-compliance-reviewer.md` | 個人情報保護法、委託先管理、privacy review へ調整 |
| Technical Content Strategist | `marketing/marketing-note-qiita-zenn-strategist.md` | note / Qiita / Zenn 技術広報へ特化 |
| Backend Architect | `engineering/engineering-japanese-backend-architect.md` | API、DB、batch、監査ログ、運用を日本の業務 system 向けに調整 |
| Data Engineer | `engineering/engineering-japanese-data-engineer.md` | ETL / ELT、DWH、BI、CSV、data quality、個人情報へ特化 |
| Frontend Engineer | `engineering/engineering-japanese-frontend-engineer.md` | 業務画面、管理画面、form/table、IME、検収しやすい UI へ調整 |
| Mobile App Builder | `engineering/engineering-japanese-mobile-app-builder.md` | 日本向け mobile app、push、store release、support へ特化 |
| Security Engineer | `engineering/engineering-japanese-security-engineer.md` | 個人情報、委託先、監査、社内 system risk を追加 |
| SRE | `engineering/engineering-japanese-sre.md` | 障害報告、保守契約、顧客影響、runbook を日本運用向けに調整 |
| Database Optimizer | `engineering/engineering-japanese-database-optimizer.md` | 帳票、CSV、batch、migration、rollback を重視 |
| Legacy Modernization Engineer | `engineering/engineering-japanese-legacy-modernization-engineer.md` | legacy system 調査と段階移行へ特化 |
| Performance Engineer | `engineering/engineering-japanese-performance-engineer.md` | 業務 peak、batch、DB、frontend、外部連携の性能改善へ特化 |
| Workflow Steward | `project-management/project-management-backlog-redmine-jira-steward.md` | Backlog / Redmine / Jira の日本現場運用へ拡張 |
| Product Manager | `product/product-japanese-product-manager.md` | 日本市場、顧客要望、受入条件、業務 impact を重視 |
| B2B SaaS Planner | `product/product-japanese-b2b-saas-planner.md` | B2B SaaS の契約、権限、CS、onboarding へ特化 |
| QA Planner | `testing/testing-japanese-qa-planner.md` | 単体、結合、総合、受入、回帰の QA 計画へ拡張 |
| API Tester | `testing/testing-japanese-api-tester.md` | API contract、認証認可、異常系、検収 evidence へ特化 |
| CSV / Excel Tester | `testing/testing-shift-jis-csv-tester.md` | 日本業務で頻出する CSV / Excel / 文字コード検証へ特化 |
| Incident Report Writer | `support/support-japanese-incident-report-writer.md` | 障害報告書、時系列、再発防止へ特化 |
| Proposal Writer | `sales/sales-japanese-rfp-response-writer.md` | RFP、提案書、見積前提、保守運用へ調整 |
| Sales Engineer | `sales/sales-japanese-sales-engineer.md` | 技術商談、demo、PoC、feasibility、RFP 質問回答へ特化 |
| Technical Writer | `engineering/engineering-japanese-technical-writer.md` | 設計書、API document、runbook、検収資料へ特化 |
| Public Sector DX Consultant | `specialized/japanese-public-sector-dx-consultant.md` | 自治体 DX、公共調達、アクセシビリティへ特化 |
| Paid Media Strategist | `paid-media/paid-media-japan-search-social-strategist.md` | 日本 B2B / EC 向け検索・SNS広告運用へ特化 |
| HR Performance Reviewer | `hr/hr-japanese-performance-review-facilitator.md` | IT 職種の目標設定、1on1、評価 feedback へ特化 |
| Design System Maintainer | `design/design-japanese-design-system-maintainer.md` | 業務 UI の component、文言、accessibility、実装連携へ特化 |
| Tool Evaluator | `testing/testing-japanese-tool-evaluator.md` | SaaS / AI tool / 開発支援 tool の導入評価へ特化 |
| Knowledge Base Steward | `specialized/specialized-japanese-knowledge-base-steward.md` | 社内 wiki、runbook、FAQ、document governance へ特化 |

## Backlog

| Reference Role | Japanese Agent Candidate |
| --- | --- |
| Lifestyle Social Operator | `marketing/marketing-instagram-lemon8-operator.md` |
| Short Video Strategist | `marketing/marketing-tiktok-japan-strategist.md` |
| Customer Support Analytics | `support/support-japanese-support-analytics-reporter.md` |
| Account Strategist | `sales/sales-japanese-account-strategist.md` |
| Prompt Engineer | `specialized/specialized-japanese-prompt-engineer.md` |
| Meeting Assistant | `specialized/specialized-japanese-meeting-assistant.md` |
| Risk Assessor | `specialized/specialized-japanese-risk-assessor.md` |
