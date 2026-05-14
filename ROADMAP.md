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
| Business Analyst | `project-management/project-management-japanese-business-analyst.md` | 現行業務、業務 flow、要件差分、受入条件へ特化 |
| Release Manager | `project-management/project-management-japanese-release-manager.md` | release 判定、作業手順、切り戻し、顧客通知へ特化 |
| Software Architect | `engineering/engineering-japanese-sier-architect.md` | SIer / 受託開発の基本設計、詳細設計、非機能、移行へ特化 |
| Code Reviewer | `engineering/engineering-japanese-code-reviewer.md` | 日本語レビュー、重大度、証跡、承認条件へ調整 |
| Requirements Engineer | `engineering/engineering-japanese-requirements-engineer.md` | 要件定義、受入条件、仕様確認へ特化 |
| Test Evidence Collector | `testing/testing-evidence-collector-ja.md` | テスト証跡、検収、CI、スクリーンショット整理へ日本化 |
| Collaboration Integration Engineer | `engineering/engineering-line-works-integration-developer.md` | LINE WORKS 連携へ特化 |
| Business App Developer | `engineering/engineering-kintone-developer.md` | kintone 業務アプリ開発へ特化 |
| Privacy / Compliance Reviewer | `legal/legal-japanese-privacy-compliance-reviewer.md` | 個人情報保護法、委託先管理、privacy review へ調整 |
| Data Privacy Officer | `legal/legal-japanese-data-privacy-officer.md` | data inventory、委託先、保存期間、開示請求、漏えい対応へ特化 |
| Policy Writer | `legal/legal-japanese-policy-writer.md` | IT、security、SaaS 利用、委託先向け社内 policy へ特化 |
| AI Policy Writer | `legal/legal-japanese-ai-policy-writer.md` | 生成 AI / AI tool 利用 policy、禁止用途、承認 flow へ特化 |
| Technical Content Strategist | `marketing/marketing-note-qiita-zenn-strategist.md` | note / Qiita / Zenn 技術広報へ特化 |
| Developer Advocate | `marketing/marketing-japanese-developer-advocate.md` | API / SDK / OSS の sample、workshop、developer feedback へ特化 |
| Product Marketing Manager | `marketing/marketing-japanese-product-marketing-manager.md` | 日本市場向け positioning、message、launch、sales enablement へ特化 |
| Market Researcher | `marketing/marketing-japanese-market-researcher.md` | 日本市場の市場規模、競合、購買 process、検証論点へ特化 |
| Case Study Writer | `marketing/marketing-japanese-case-study-writer.md` | 導入事例、顧客 proof、公開許諾、営業活用へ特化 |
| Community Manager | `marketing/marketing-japanese-community-manager.md` | user group、developer community、feedback loop へ特化 |
| Customer Marketing Manager | `marketing/marketing-japanese-customer-marketing-manager.md` | 既存顧客 marketing、advocacy、更新 / 拡張支援へ特化 |
| Lifestyle Social Operator | `marketing/marketing-instagram-lemon8-operator.md` | Instagram / Lemon8 の採用広報、event、導入事例展開へ特化 |
| Short Video Strategist | `marketing/marketing-tiktok-japan-strategist.md` | TikTok / short video の採用広報、event、認知拡大へ特化 |
| Backend Architect | `engineering/engineering-japanese-backend-architect.md` | API、DB、batch、監査ログ、運用を日本の業務 system 向けに調整 |
| Data Engineer | `engineering/engineering-japanese-data-engineer.md` | ETL / ELT、DWH、BI、CSV、data quality、個人情報へ特化 |
| Data Governance Steward | `engineering/engineering-japanese-data-governance-steward.md` | data owner、catalog、quality、access、retention rule へ特化 |
| Frontend Engineer | `engineering/engineering-japanese-frontend-engineer.md` | 業務画面、管理画面、form/table、IME、検収しやすい UI へ調整 |
| Mobile App Builder | `engineering/engineering-japanese-mobile-app-builder.md` | 日本向け mobile app、push、store release、support へ特化 |
| Security Engineer | `engineering/engineering-japanese-security-engineer.md` | 個人情報、委託先、監査、社内 system risk を追加 |
| SRE | `engineering/engineering-japanese-sre.md` | 障害報告、保守契約、顧客影響、runbook を日本運用向けに調整 |
| Observability Engineer | `engineering/engineering-japanese-observability-engineer.md` | log、metrics、trace、dashboard、alert、監査 log へ特化 |
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
| IT Asset Manager | `support/support-japanese-it-asset-manager.md` | PC、SaaS license、account、貸与品、入退社管理へ特化 |
| Proposal Writer | `sales/sales-japanese-rfp-response-writer.md` | RFP、提案書、見積前提、保守運用へ調整 |
| Sales Engineer | `sales/sales-japanese-sales-engineer.md` | 技術商談、demo、PoC、feasibility、RFP 質問回答へ特化 |
| Account Strategist | `sales/sales-japanese-account-strategist.md` | 既存顧客の更新、拡張提案、stakeholder mapping へ特化 |
| Partner Alliance Manager | `sales/sales-japanese-partner-alliance-manager.md` | partner alliance、co-marketing、共同提案、責任分界へ特化 |
| Sales Operations Analyst | `sales/sales-japanese-sales-operations-analyst.md` | pipeline、forecast、CRM hygiene、sales KPI へ特化 |
| Revenue Operations Manager | `sales/sales-japanese-revenue-operations-manager.md` | marketing / sales / CS / finance の revenue lifecycle へ特化 |
| Technical Writer | `engineering/engineering-japanese-technical-writer.md` | 設計書、API document、runbook、検収資料へ特化 |
| Public Sector DX Consultant | `specialized/japanese-public-sector-dx-consultant.md` | 自治体 DX、公共調達、アクセシビリティへ特化 |
| Paid Media Strategist | `paid-media/paid-media-japan-search-social-strategist.md` | 日本 B2B / EC 向け検索・SNS広告運用へ特化 |
| Pricing Strategist | `specialized/specialized-japanese-pricing-strategist.md` | pricing、packaging、見積前提、discount rule へ特化 |
| HR Performance Reviewer | `hr/hr-japanese-performance-review-facilitator.md` | IT 職種の目標設定、1on1、評価 feedback へ特化 |
| Corporate Training Designer | `hr/hr-japanese-corporate-training-designer.md` | security、AI 活用、開発 process、enablement 研修へ特化 |
| Design System Maintainer | `design/design-japanese-design-system-maintainer.md` | 業務 UI の component、文言、accessibility、実装連携へ特化 |
| Tool Evaluator | `testing/testing-japanese-tool-evaluator.md` | SaaS / AI tool / 開発支援 tool の導入評価へ特化 |
| Knowledge Base Steward | `specialized/specialized-japanese-knowledge-base-steward.md` | 社内 wiki、runbook、FAQ、document governance へ特化 |
| Customer Support Analytics | `support/support-japanese-support-analytics-reporter.md` | 問い合わせ、SLA、FAQ、product feedback の分析へ特化 |
| Prompt Engineer | `specialized/specialized-japanese-prompt-engineer.md` | 社内 AI 活用 prompt、評価、guardrail へ特化 |
| Meeting Assistant | `specialized/specialized-japanese-meeting-assistant.md` | 顧客定例、議事録、決定事項、課題管理へ特化 |
| Risk Assessor | `specialized/specialized-japanese-risk-assessor.md` | project、release、AI 活用の risk assessment へ特化 |
| Automation Governance Architect | `specialized/specialized-japanese-automation-governance-architect.md` | RPA、AI agent、bot、workflow automation の governance へ特化 |
| FinOps Analyst | `finance/finance-japanese-finops-analyst.md` | cloud / SaaS cost、unit economics、配賦、削減施策へ特化 |
| Internal Audit Coordinator | `finance/finance-japanese-internal-audit-coordinator.md` | IT 統制、権限、変更管理、証跡、監査対応へ特化 |
| Procurement Manager | `supply-chain/supply-chain-japanese-procurement-manager.md` | SaaS、cloud、開発委託、hardware の調達 process へ特化 |
| Vendor Risk Manager | `supply-chain/supply-chain-japanese-vendor-risk-manager.md` | vendor security、privacy、BCP、契約、exit risk へ特化 |
| Business Continuity Planner | `specialized/specialized-japanese-business-continuity-planner.md` | BCP、DR、災害対応、代替運用、訓練 plan へ特化 |

## Backlog

| Reference Role | Japanese Agent Candidate |
| --- | --- |
| Quality Assurance Manager | `testing/testing-japanese-quality-assurance-manager.md` |
| Change Management Lead | `project-management/project-management-japanese-change-management-lead.md` |
| Service Delivery Manager | `support/support-japanese-service-delivery-manager.md` |
| Enterprise Architect | `engineering/engineering-japanese-enterprise-architect.md` |
| Knowledge Commerce Strategist | `marketing/marketing-japanese-knowledge-commerce-strategist.md` |
