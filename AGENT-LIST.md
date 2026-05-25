# Agent List

Total agents: 281 (⭐ 97 japan-original + 184 upstream-aligned)

⭐ = Japan-market original agent (independently designed for Japanese IT / SaaS / SIer / 製造業 DX / 公共 sector workflows).
Other rows = upstream-aligned agents derived from [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents), tracked with `source`, `upstream_path`, and `translation_status` frontmatter.

## Academic

Total: 5 (⭐ 0 japan-original + 5 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
|  | 日本向け文化人類学リサーチャー | upstream | skeleton | Anthropologist | 日本の利用者文化、業務慣習、組織行動、地域差を ethnographic research として整理し、IT 企画・UX・市場参入に活かす学術・リサーチ agent。 | `academic/academic-anthropologist.md` |
|  | 日本向け地理・地域分析リサーチャー | upstream | skeleton | Geographer | 地域差、商圏、移動、災害、自治体、インフラ制約を分析し、日本向け IT 企画・展開計画へ落とし込む学術・リサーチ agent。 | `academic/academic-geographer.md` |
|  | 日本向け歴史リサーチャー | upstream | skeleton | Historian | 産業史、制度変遷、企業沿革、地域史を調査し、IT 企画・市場理解・ブランド narrative に活かす学術・リサーチ agent。 | `academic/academic-historian.md` |
|  | 日本向けナラティブ分析者 | upstream | skeleton | Narratologist | 物語構造、語り口、ブランド narrative、政策・企業メッセージを分析し、日本向け IT 提案・UX・広報に活かす学術・リサーチ agent。 | `academic/academic-narratologist.md` |
|  | 日本向け心理リサーチャー | upstream | skeleton | Psychologist | 行動心理、意思決定、motivation、認知負荷、組織心理を分析し、日本向け UX・導入定着・業務変革に活かす学術・リサーチ agent。 | `academic/academic-psychologist.md` |

## Engineering

Total: 49 (⭐ 20 japan-original + 29 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本向けバックエンドアーキテクト | japan-original |  |  | 日本の業務システム、SaaS、受託開発向けに API、database、batch、認証認可、監査ログ、運用保守を設計する backend architect。 | `engineering/engineering-japanese-backend-architect.md` |
| ⭐ | 日本語コードレビュアー | japan-original |  |  | 日本語チーム向け code review 専門家。丁寧な表現、明確な重大度、証跡、受入条件、保守運用リスクを重視する。 | `engineering/engineering-japanese-code-reviewer.md` |
| ⭐ | 日本向けデータエンジニア | japan-original |  |  | 日本の業務システム、SaaS、EC、製造業 DX 向けに ETL / ELT、DWH、BI、CSV、個人情報、データ品質を設計する data engineer。 | `engineering/engineering-japanese-data-engineer.md` |
| ⭐ | 日本向けデータガバナンス管理者 | japan-original |  |  | 日本企業の SaaS / 業務システム / DWH で data owner、data catalog、品質、権限、個人情報、監査、利用 rule を整える data governance steward。 | `engineering/engineering-japanese-data-governance-steward.md` |
| ⭐ | 日本向けデータベース最適化エンジニア | japan-original |  |  | 業務システムの database schema、query、index、migration、帳票・CSV・batch workload を最適化する専門家。 | `engineering/engineering-japanese-database-optimizer.md` |
| ⭐ | 日本向けエンタープライズアーキテクト | japan-original |  |  | 日本企業の複数 system、業務、data、security、cloud、integration、governance を横断して target architecture と移行 roadmap を設計する enterprise architect。 | `engineering/engineering-japanese-enterprise-architect.md` |
| ⭐ | 日本向けフロントエンドエンジニア | japan-original |  |  | 日本の業務画面、管理画面、SaaS UI 向けに React/Vue、form、table、accessibility、入力補助、検証しやすい UI を実装する frontend engineer。 | `engineering/engineering-japanese-frontend-engineer.md` |
| ⭐ | レガシーモダナイゼーションエンジニア | japan-original |  |  | 旧 Java、COBOL、VB、Access、Excel VBA、on-prem system を段階的に modernize する専門家。現行業務を止めずに移行計画を作る。 | `engineering/engineering-japanese-legacy-modernization-engineer.md` |
| ⭐ | 日本向けモバイルアプリエンジニア | japan-original |  |  | 日本向け iOS / Android / React Native / Flutter app の業務要件、push 通知、認証、審査、運用、障害対応を考慮して実装する mobile app builder。 | `engineering/engineering-japanese-mobile-app-builder.md` |
| ⭐ | 日本向けオブザーバビリティエンジニア | japan-original |  |  | 日本の SaaS / 業務システム運用に合わせて log、metrics、trace、dashboard、alert、SLO、監査 log を設計する observability engineer。 | `engineering/engineering-japanese-observability-engineer.md` |
| ⭐ | 日本向け OSS ローカライゼーションエンジニア | japan-original |  |  | GitHub の OSS project（README、docs、CONTRIBUTING、issue / PR template、release notes、CLI message）を、日本の開発者が違和感なく読める日本語に翻訳・適配する。直訳ではなく、用語集、code block / link / image alt / heading anchor の保持、docs/ja 構造、CI translation diff、upstream 追従の運用までを含めて担当する。 | `engineering/engineering-japanese-oss-localization-engineer.md` |
| ⭐ | 日本向けパフォーマンスエンジニア | japan-original |  |  | 日本の業務システム、SaaS、EC における response time、batch、DB、frontend、外部連携の性能課題を調査し改善計画を作る performance engineer。 | `engineering/engineering-japanese-performance-engineer.md` |
| ⭐ | 要件定義エンジニア | japan-original |  |  | 日本の受託開発、SI、SaaS 開発で要件定義、受入条件、仕様確認、未決事項整理を行う専門家。曖昧な依頼を実装可能な要件へ落とし込む。 | `engineering/engineering-japanese-requirements-engineer.md` |
| ⭐ | 日本向けセキュリティエンジニア | japan-original |  |  | 日本企業の web application、業務システム、SaaS に対して threat modeling、認証認可、個人情報、監査ログ、脆弱性対応を review する。 | `engineering/engineering-japanese-security-engineer.md` |
| ⭐ | 日本 SIer アーキテクト | japan-original |  |  | SIer / 受託開発向けの architecture 専門家。基本設計、詳細設計、非機能要件、移行、保守運用、既存システム連携を現実的に設計する。 | `engineering/engineering-japanese-sier-architect.md` |
| ⭐ | 日本向けソフトウェアサプライチェーンエンジニア | japan-original |  |  | npm / PyPI / Maven などの外部依存、OSS license、SBOM、CVE、lockfile、cooldown、provenance、委託先が入れた package、自社 publish 時の security を日本の IT 開発現場向けに review する。情シス承認、監査証跡、Backlog / Redmine / Jira と紐づく形で整理する。 | `engineering/engineering-japanese-software-supply-chain-engineer.md` |
| ⭐ | 日本向け SRE | japan-original |  |  | 日本の SaaS / 業務システム運用に合わせて SLO、監視、障害対応、当番、ポストモーテム、運用改善を設計する SRE。 | `engineering/engineering-japanese-sre.md` |
| ⭐ | 日本向け技術ドキュメントライター | japan-original |  |  | 日本の IT 開発、SaaS、SIer、受託開発向けに設計書、API document、運用手順、release note、検収資料を分かりやすく整える technical writer。 | `engineering/engineering-japanese-technical-writer.md` |
| ⭐ | kintone 開発エンジニア | japan-original |  |  | Cybozu kintone の業務アプリ、JavaScript customize、REST API、plugin、外部連携を設計・実装する専門家。 | `engineering/engineering-kintone-developer.md` |
| ⭐ | LINE WORKS 連携エンジニア | japan-original |  |  | LINE WORKS bot、通知、承認、業務システム連携を設計・実装する専門家。日本企業の社内コミュニケーションと運用に合わせる。 | `engineering/engineering-line-works-integration-developer.md` |
|  | 日本向け AI データ修復エンジニア | upstream | skeleton | AI Data Remediation Engineer | 日本語データ、個人情報、業務 CSV、FAQ、RAG corpus の品質問題を検出・修復する AI / data engineering agent。 | `engineering/engineering-ai-data-remediation-engineer.md` |
|  | 日本向け AI エンジニア | upstream | skeleton | AI Engineer | 日本企業向けに LLM、RAG、agent、評価、セキュリティ、運用を実装する AI engineering agent。 | `engineering/engineering-ai-engineer.md` |
|  | 日本向け自律最適化アーキテクト | upstream | skeleton | Autonomous Optimization Architect | 日本企業向けに AI agent、optimization loop、human approval、monitoring を組み込んだ自律改善 system を設計する agent。 | `engineering/engineering-autonomous-optimization-architect.md` |
|  | 日本向け Backend Architect | upstream | skeleton | Backend Architect | 日本の業務システム、SaaS、受託開発で API、database、batch、認証認可、監査ログ、運用保守を設計する backend architect。 | `engineering/engineering-backend-architect.md` |
|  | 日本向け CMS 開発者 | upstream | skeleton | CMS Developer | 日本の企業サイト、自治体、EC、オウンドメディア向けに CMS 設計、運用、権限、SEO、公開承認を実装する agent。 | `engineering/engineering-cms-developer.md` |
|  | 日本向け Code Reviewer | upstream | skeleton | Code Reviewer | 日本の開発チーム向けに、重大度、根拠、保守運用リスク、受入条件を明確にした code review を行う agent。 | `engineering/engineering-code-reviewer.md` |
|  | 日本向けコードベースオンボーディングエンジニア | upstream | skeleton | Codebase Onboarding Engineer | 日本の開発チーム向けに既存 codebase の構造、開発手順、設計意図、初回 task を整理する onboarding agent。 | `engineering/engineering-codebase-onboarding-engineer.md` |
|  | 日本向け Data Engineer | upstream | skeleton | Data Engineer | 日本の業務システム、SaaS、EC、製造業 DX 向けに ETL / ELT、DWH、BI、CSV、個人情報、データ品質を設計する agent。 | `engineering/engineering-data-engineer.md` |
|  | 日本向け Database Optimizer | upstream | skeleton | Database Optimizer | 日本の業務システムで query、index、schema、migration、batch、帳票、CSV workload を最適化する database agent。 | `engineering/engineering-database-optimizer.md` |
|  | 日本向け DevOps 自動化エンジニア | upstream | skeleton | DevOps Automator | 日本の開発・運用現場に合わせて CI/CD、IaC、release、監視、rollback、権限管理を自動化する agent。 | `engineering/engineering-devops-automator.md` |
|  | 日本向けメールインテリジェンスエンジニア | upstream | skeleton | Email Intelligence Engineer | 日本語メール、問い合わせ、営業返信、CS 対応を分類・要約・自動化する email intelligence agent。 | `engineering/engineering-email-intelligence-engineer.md` |
|  | 日本向け組み込みファームウェアエンジニア | upstream | skeleton | Embedded Firmware Engineer | 日本の製造、IoT、ロボット、医療・産業機器向けに firmware、通信、更新、検査、保守を設計する agent。 | `engineering/engineering-embedded-firmware-engineer.md` |
|  | 日本向け LINE WORKS / Slack 連携開発者 | upstream | skeleton | Feishu Integration Developer | 日本企業の LINE WORKS、Slack、Teams、kintone、承認・通知業務を連携する integration agent。 | `engineering/engineering-feishu-integration-developer.md` |
|  | 日本向け 3D プリンタ材料最適化専門家 | upstream | skeleton | Filament Optimization Specialist | 日本の試作、製造、教育現場向けに 3D printer filament、造形条件、品質、検査、材料選定を最適化する agent。 | `engineering/engineering-filament-optimization-specialist.md` |
|  | 日本向け Frontend Developer | upstream | skeleton | Frontend Developer | 日本の業務画面、SaaS、EC、管理画面向けに React / Vue、form、table、アクセシビリティ、入力補助を実装する frontend agent。 | `engineering/engineering-frontend-developer.md` |
|  | 日本向け Git ワークフローマスター | upstream | skeleton | Git Workflow Master | 日本の開発チーム向けに branch、PR、commit、release、hotfix、権限、レビュー運用を整える Git workflow agent。 | `engineering/engineering-git-workflow-master.md` |
|  | 日本向けインシデント対応指揮者 | upstream | skeleton | Incident Response Commander | 日本の SaaS / 業務システム運用で障害対応、顧客連絡、復旧、暫定対応、再発防止を指揮する agent。 | `engineering/engineering-incident-response-commander.md` |
|  | 日本向け最小変更エンジニア | upstream | skeleton | Minimal Change Engineer | 既存仕様、保守運用、検収リスクを守りながら、目的達成に必要な最小差分で修正する engineering agent。 | `engineering/engineering-minimal-change-engineer.md` |
|  | 日本向け Mobile App Builder | upstream | skeleton | Mobile App Builder | 日本向け iOS / Android / React Native / Flutter app の認証、push、決済、審査、運用を実装する mobile agent。 | `engineering/engineering-mobile-app-builder.md` |
|  | 日本向け高速プロトタイピングエンジニア | upstream | skeleton | Rapid Prototyper | 日本の新規事業、PoC、営業 demo、社内検証向けに短期間で検証可能な prototype を作る engineering agent。 | `engineering/engineering-rapid-prototyper.md` |
|  | 日本向け Security Engineer | upstream | skeleton | Security Engineer | 日本企業の Web / SaaS / 業務システムに対して脅威モデリング、認証認可、個人情報、脆弱性対応を支援する agent。 | `engineering/engineering-security-engineer.md` |
|  | 日本向けシニア開発者 | upstream | skeleton | Senior Developer | 日本の開発現場で設計、実装、レビュー、障害対応、育成、技術的意思決定をリードする senior developer agent。 | `engineering/engineering-senior-developer.md` |
|  | 日本向けソフトウェアアーキテクト | upstream | skeleton | Software Architect | 日本の SaaS、SI、受託開発、業務システム向けに全体設計、非機能、移行、運用保守を設計する agent。 | `engineering/engineering-software-architect.md` |
|  | 日本向け Solidity スマートコントラクトエンジニア | upstream | skeleton | Solidity Smart Contract Engineer | 日本向け Web3 / blockchain project の Solidity contract、監査、運用、法務・セキュリティ論点を整理する agent。 | `engineering/engineering-solidity-smart-contract-engineer.md` |
|  | 日本向けSRE (Site Reliability Engineer) | upstream | skeleton | SRE (Site Reliability Engineer) | 日本の SaaS / 業務システム運用に合わせて SLO、監視、障害対応、当番、ポストモーテム、運用改善を設計する SRE agent。 | `engineering/engineering-sre.md` |
|  | 日本向け Technical Writer | upstream | skeleton | Technical Writer | 日本の IT 開発、SaaS、SI、受託開発向けに設計書、API docs、運用手順、release note、検収資料を整える agent。 | `engineering/engineering-technical-writer.md` |
|  | 日本向け脅威検知エンジニア | upstream | skeleton | Threat Detection Engineer | 日本企業の cloud、SaaS、endpoint、認証ログから脅威を検知し、SOC / CSIRT 連携を設計する security agent。 | `engineering/engineering-threat-detection-engineer.md` |
|  | 日本向け音声 AI 連携エンジニア | upstream | skeleton | Voice AI Integration Engineer | 日本語音声認識、音声合成、電話、コールセンター、会議要約、voice bot を連携する AI engineering agent。 | `engineering/engineering-voice-ai-integration-engineer.md` |
|  | 日本向け LINE ミニアプリ開発者 | upstream | skeleton | WeChat Mini Program Developer | 日本向け LINE ミニアプリ / LIFF、予約、会員証、EC、CRM、店舗導線を実装する agent。 | `engineering/engineering-wechat-mini-program-developer.md` |

## Project Management

Total: 13 (⭐ 7 japan-original + 6 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 受入条件ライター | japan-original |  |  | 要件、仕様、顧客要望を testable な受入条件、検収条件、確認観点へ変換する専門家。 | `project-management/project-management-acceptance-criteria-writer.md` |
| ⭐ | Backlog / Redmine / Jira 運用管理者 | japan-original |  |  | Backlog、Redmine、Jira の ticket workflow、status、priority、label、release、運用ルールを整備する project workflow steward。 | `project-management/project-management-backlog-redmine-jira-steward.md` |
| ⭐ | 日本向けビジネスアナリスト | japan-original |  |  | 日本の IT / SI / SaaS 開発で現行業務、業務フロー、要件差分、関係者、受入条件を整理する business analyst。 | `project-management/project-management-japanese-business-analyst.md` |
| ⭐ | 日本向け変更管理リード | japan-original |  |  | 日本の IT project / SaaS 運用で scope change、仕様変更、影響分析、承認、周知、移行を管理する change management lead。 | `project-management/project-management-japanese-change-management-lead.md` |
| ⭐ | 日本 IT プロジェクトマネージャー | japan-original |  |  | 日本の IT / SI / 受託開発で WBS、課題管理、進捗会議、議事録、リスク、検収を管理する PM。 | `project-management/project-management-japanese-pm.md` |
| ⭐ | 日本向けリリースマネージャー | japan-original |  |  | 日本の IT / SaaS / 受託開発で release 判定、作業手順、切り戻し、顧客通知、検収 evidence、関係者承認を管理する release manager。 | `project-management/project-management-japanese-release-manager.md` |
| ⭐ | 日本向け上流追従コーディネーター | japan-original |  |  | 上流 OSS の更新を watch し、fork 側の追従計画を立てる project coordinator。upstream commit / release の分類（feature / breaking / docs / security）、fork 独自改修との衝突確認、翻訳追従、release note への反映、追従 PR の Backlog / Redmine / Jira ticket 化、四半期 sync 健全性 review までを担当する。 | `project-management/project-management-japanese-upstream-sync-coordinator.md` |
|  | 日本向け実験管理担当 | upstream | skeleton | Experiment Tracker | 仮説、A/B test、PoC、pilot、効果測定、意思決定 log を日本の product / DX project 向けに管理するプロジェクト管理 agent。 | `project-management/project-management-experiment-tracker.md` |
|  | 日本向け Jira ワークフロー管理者 | upstream | skeleton | Jira Workflow Steward | Jira / Backlog / Redmine の issue type、status、priority、承認、検収、release workflow を日本の開発現場向けに整備するプロジェクト管理 agent。 | `project-management/project-management-jira-workflow-steward.md` |
|  | 日本向けプロジェクト推進担当 | upstream | skeleton | Project Shepherd | 進捗、blocker、依存関係、会議体、意思決定、顧客調整を日本の IT project で前に進めるプロジェクト管理 agent。 | `project-management/project-management-project-shepherd.md` |
|  | 日本向けスタジオ運営担当 | upstream | skeleton | Studio Operations | 複数 project の capacity、tool、会議体、採用・外注、品質 gate、運用 rhythm を整えるプロジェクト管理 agent。 | `project-management/project-management-studio-operations.md` |
|  | 日本向けスタジオプロデューサー | upstream | skeleton | Studio Producer | 複数職能の成果物、schedule、quality、stakeholder expectation を統合し、日本の制作・開発 project を出荷へ導くプロジェクト管理 agent。 | `project-management/project-management-studio-producer.md` |
|  | 日本向けシニアプロジェクトマネージャー | upstream | skeleton | Senior Project Manager | 大規模 IT / SIer / SaaS 導入 project の計画、risk、stakeholder、品質、検収、運用移行を統括するプロジェクト管理 agent。 | `project-management/project-manager-senior.md` |

## Testing

Total: 14 (⭐ 6 japan-original + 8 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | テストエビデンス収集担当 | japan-original |  |  | 日本の検収・品質保証で必要な test evidence、CI 結果、スクリーンショット、ログ、再現手順を整理する専門家。 | `testing/testing-evidence-collector-ja.md` |
| ⭐ | 日本向け API テスター | japan-original |  |  | 日本の業務システム、SaaS、外部連携 API に対して contract、認証認可、異常系、冪等性、監査ログ、検収 evidence を確認する API tester。 | `testing/testing-japanese-api-tester.md` |
| ⭐ | 日本向け QA プランナー | japan-original |  |  | 日本の開発工程に合わせて単体、結合、総合、受入、回帰テストの計画と観点を作る QA planner。 | `testing/testing-japanese-qa-planner.md` |
| ⭐ | 日本向け品質保証マネージャー | japan-original |  |  | 日本の IT / SaaS / 受託開発で品質方針、QA gate、不具合傾向、検収 readiness、改善計画を管理する quality assurance manager。 | `testing/testing-japanese-quality-assurance-manager.md` |
| ⭐ | 日本 IT ツール評価担当 | japan-original |  |  | 日本企業で導入する SaaS、開発支援 tool、AI tool、monitoring、ticket system を機能、security、費用、運用、契約の観点で評価する specialist。 | `testing/testing-japanese-tool-evaluator.md` |
| ⭐ | Shift_JIS / CSV テスター | japan-original |  |  | 日本の業務システムで頻出する CSV、Excel、Shift_JIS、UTF-8 BOM、全角半角、郵便番号、電話番号、日付形式を検証する specialist。 | `testing/testing-shift-jis-csv-tester.md` |
|  | 日本向け Accessibility Auditor | upstream | skeleton | Accessibility Auditor | JIS X 8341-3、WCAG、日本語 UI、公共・企業サイトの要件に合わせてアクセシビリティ監査観点を整理する QA agent。 | `testing/testing-accessibility-auditor.md` |
|  | 日本向け API Tester | upstream | skeleton | API Tester | 日本の B2B SaaS、SI、社内システム連携で必要な API 契約、認証、異常系、証跡を検証する QA agent。 | `testing/testing-api-tester.md` |
|  | 日本向け Evidence Collector | upstream | skeleton | Evidence Collector | 検収、監査、障害報告、QA 判定に必要なスクリーンショット、ログ、テスト結果、チケット証跡を整理する支援 agent。 | `testing/testing-evidence-collector.md` |
|  | 日本向け Performance Benchmarker | upstream | skeleton | Performance Benchmarker | 日本の SLA、ピーク時間、モバイル利用、クラウド費用を踏まえて性能試験とベンチマークを設計・評価する QA agent。 | `testing/testing-performance-benchmarker.md` |
|  | 日本向け Reality Checker | upstream | skeleton | Reality Checker | 企画、開発、QA、リリース判断の楽観的な主張を、証跡・制約・現場実態に照らして検証する QA agent。 | `testing/testing-reality-checker.md` |
|  | 日本向け Test Results Analyzer | upstream | skeleton | Test Results Analyzer | テスト結果、欠陥傾向、品質ゲート、残リスクを日本のリリース判定・検収報告向けに整理する QA agent。 | `testing/testing-test-results-analyzer.md` |
|  | 日本向け Tool Evaluator | upstream | skeleton | Tool Evaluator | 日本企業の購買、セキュリティ、運用、サポート、費用対効果に合わせて開発・QA・AI ツールを評価する支援 agent。 | `testing/testing-tool-evaluator.md` |
|  | 日本向け Workflow Optimizer | upstream | skeleton | Workflow Optimizer | 日本の開発、QA、CS、保守運用にある手戻り・承認待ち・属人化を見つけ、現実的な workflow 改善へ落とし込む agent。 | `testing/testing-workflow-optimizer.md` |

## Product

Total: 7 (⭐ 2 japan-original + 5 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本 B2B SaaS プランナー | japan-original |  |  | 日本の B2B SaaS における onboarding、権限、契約、請求、管理画面、CS 運用を踏まえた product planning を行う。 | `product/product-japanese-b2b-saas-planner.md` |
| ⭐ | 日本向けプロダクトマネージャー | japan-original |  |  | 日本市場向け SaaS / 業務プロダクトの課題整理、優先順位、ロードマップ、受入条件、顧客説明を設計する product manager。 | `product/product-japanese-product-manager.md` |
|  | 日本向け行動ナッジ設計者 | upstream | skeleton | Behavioral Nudge Engine | 行動科学、認知負荷、choice architecture を使い、日本の B2B SaaS / 業務 UI / 公共 DX の利用定着を倫理的に改善するプロダクト agent。 | `product/product-behavioral-nudge-engine.md` |
|  | 日本向けフィードバック統合担当 | upstream | skeleton | Feedback Synthesizer | 営業、CS、support、NPS、商談、解約理由、問い合わせを統合し、日本の product decision に使える insight へ変換するプロダクト agent。 | `product/product-feedback-synthesizer.md` |
|  | 日本向け Product Manager | upstream | skeleton | Product Manager | 日本の B2B SaaS / 業務 system / SIer 開発で、課題、価値、roadmap、受入条件、顧客説明を統合するプロダクト agent。 | `product/product-manager.md` |
|  | 日本向けスプリント優先順位設計者 | upstream | skeleton | Sprint Prioritizer | 顧客影響、売上、保守負債、障害 risk、依存関係を踏まえ、日本の開発 sprint backlog を優先順位付けするプロダクト agent。 | `product/product-sprint-prioritizer.md` |
|  | 日本向けプロダクトトレンドリサーチャー | upstream | skeleton | Trend Researcher | 日本市場、業界規制、競合、技術潮流、顧客行動を調査し、product strategy と roadmap に活かすプロダクト agent。 | `product/product-trend-researcher.md` |

## Marketing

Total: 46 (⭐ 16 japan-original + 30 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本向け Instagram / Lemon8 運用者 | japan-original |  |  | 日本の IT 企業、B2B SaaS、採用広報、イベント、導入事例向けに Instagram / Lemon8 の企画、投稿、導線、効果測定を設計する social operator。 | `marketing/marketing-instagram-lemon8-operator.md` |
| ⭐ | 日本向け AI 引用戦略家 | japan-original |  |  | ChatGPT、Claude、Gemini、Perplexity などの生成 AI / answer engine で自社・製品・OSS がどのように引用・推薦されるかを監査し、AEO / GEO 改善策を作る strategist。 | `marketing/marketing-japanese-ai-citation-strategist.md` |
| ⭐ | 日本向け導入事例ライター | japan-original |  |  | 日本の B2B SaaS、SI、IT service 向けに顧客導入事例、課題、選定理由、効果、公開許諾、営業活用 copy を作る case study writer。 | `marketing/marketing-japanese-case-study-writer.md` |
| ⭐ | 日本向けコミュニティマネージャー | japan-original |  |  | 日本の SaaS、developer community、user group、partner community 向けにイベント、投稿、moderation、feedback loop を設計する community manager。 | `marketing/marketing-japanese-community-manager.md` |
| ⭐ | 日本向けカスタマーマーケティングマネージャー | japan-original |  |  | 日本の B2B SaaS / IT service で既存顧客向け newsletter、導入事例、ユーザー会、更新促進、upsell / advocacy を設計する customer marketing manager。 | `marketing/marketing-japanese-customer-marketing-manager.md` |
| ⭐ | 日本向けデベロッパーアドボケイト | japan-original |  |  | 日本の developer audience 向けに API / SDK / OSS / SaaS platform の技術発信、sample、workshop、community feedback を設計する developer advocate。 | `marketing/marketing-japanese-developer-advocate.md` |
| ⭐ | 日本向けナレッジコマース戦略家 | japan-original |  |  | 日本市場向けに有料 newsletter、講座、template、community、法人研修などの knowledge commerce 商品を設計する strategist。 | `marketing/marketing-japanese-knowledge-commerce-strategist.md` |
| ⭐ | 日本市場リサーチャー | japan-original |  |  | 日本の B2B SaaS、IT service、SI、EC、製造業 DX 向けに市場規模、競合、顧客課題、購入プロセス、参入機会を整理する market researcher。 | `marketing/marketing-japanese-market-researcher.md` |
| ⭐ | 日本向け OSS ポジショニングライター | japan-original |  |  | 上流 OSS の README / docs を「翻訳」ではなく日本市場向けに「ポジショニングし直す」writer。日本の開発者が「なぜ使うのか」「自分の状況にどう効くか」を 30 秒で理解できる構造に書き換える。SIer / 受託 / 自社サービス / 情シスのどれに刺すかを意識し、Qiita / Zenn / note / X / GitHub Discussions への導線も設計する。 | `marketing/marketing-japanese-oss-positioning-writer.md` |
| ⭐ | 日本向けプロダクトマーケティングマネージャー | japan-original |  |  | 日本の B2B SaaS / IT service 向けに positioning、persona、message、launch plan、sales enablement、competitive note を作る product marketing manager。 | `marketing/marketing-japanese-product-marketing-manager.md` |
| ⭐ | LINE 公式アカウント運用者 | japan-original |  |  | 日本向け LINE Official Account の配信、セグメント、ステップ配信、CRM、来店・購買導線を設計する marketing operator。 | `marketing/marketing-line-official-account-operator.md` |
| ⭐ | note / Qiita / Zenn 技術広報ストラテジスト | japan-original |  |  | 日本向け技術広報、採用広報、developer marketing のために note、Qiita、Zenn、はてなブログのコンテンツ戦略を作る。 | `marketing/marketing-note-qiita-zenn-strategist.md` |
| ⭐ | 楽天 / Amazon Japan EC 運用者 | japan-original |  |  | 楽天市場、Amazon Japan、Yahoo! ショッピング、Shopify Japan の商品ページ、広告、在庫、レビュー、販促を運用する EC specialist。 | `marketing/marketing-rakuten-amazon-japan-operator.md` |
| ⭐ | セミナー / ウェビナー企画者 | japan-original |  |  | 日本の B2B SaaS / IT 企業向けに seminar、webinar、white paper、lead nurturing の企画を作る marketer。 | `marketing/marketing-seminar-webinar-planner.md` |
| ⭐ | 日本向け TikTok ストラテジスト | japan-original |  |  | 日本の IT 企業、SaaS、採用広報、developer marketing、イベント告知向けに TikTok / short video の企画、台本、配信、効果測定を設計する strategist。 | `marketing/marketing-tiktok-japan-strategist.md` |
| ⭐ | Yahoo! JAPAN / Google SEO スペシャリスト | japan-original |  |  | 日本語検索向け technical SEO、content SEO、local SEO、構造化 data、検索意図分析を行う specialist。 | `marketing/marketing-yahoo-google-japan-seo.md` |
|  | 日本向けエージェント検索最適化担当 | upstream | skeleton | Agentic Search Optimizer | ChatGPT、Perplexity、Gemini などの AI agent / answer engine に日本語で発見・引用されやすい情報設計を行う marketing agent。 | `marketing/marketing-agentic-search-optimizer.md` |
|  | 日本向け AI Citation Strategist | upstream | skeleton | AI Citation Strategist | 生成 AI / answer engine で日本語ユーザーに正しく引用・推薦されるための AEO / GEO 戦略を設計する marketing agent。 | `marketing/marketing-ai-citation-strategist.md` |
|  | 日本向けアプリストア最適化担当 | upstream | skeleton | App Store Optimizer | App Store / Google Play で日本語キーワード、説明文、スクリーンショット、レビュー改善を行う ASO agent。 | `marketing/marketing-app-store-optimizer.md` |
|  | Yahoo! JAPAN / Google SEO スペシャリスト | upstream | skeleton | Baidu SEO Specialist | Yahoo! JAPAN / Google SEO スペシャリスト として、英文上流 agency-agents の専門性を日本市場、商習慣、日本語表現、稟議・承認・運用責任に合わせて実務で使える成果物へ落とし込む マーケティング agent。 | `marketing/marketing-baidu-seo-specialist.md` |
|  | YouTube / NicoNico コンテンツ戦略家 | upstream | skeleton | Bilibili Content Strategist | 日本向けに YouTube、NicoNico、技術動画、採用広報動画、製品解説動画の企画・改善を行う marketing agent。 | `marketing/marketing-bilibili-content-strategist.md` |
|  | 日本向け書籍共同著者 | upstream | skeleton | Book Co-Author | 日本語のビジネス書、技術書、Zenn Book、同人誌、ホワイトペーパーを企画・構成・執筆支援する marketing agent。 | `marketing/marketing-book-co-author.md` |
|  | 日本向けカルーセル投稿成長エンジン | upstream | skeleton | Carousel Growth Engine | Instagram、LinkedIn、X、note 連携向けに日本語カルーセル投稿の企画・構成・改善を行う marketing agent。 | `marketing/marketing-carousel-growth-engine.md` |
|  | 日本向け EC 運用者 | upstream | skeleton | China Ecommerce Operator | 楽天市場、Amazon Japan、Yahoo! ショッピング、Shopify Japan の商品ページ、広告、レビュー、在庫、販促を運用する agent。 | `marketing/marketing-china-ecommerce-operator.md` |
|  | 日本市場ローカライゼーション戦略家 | upstream | skeleton | China Market Localization Strategist | 海外プロダクトや上流コンテンツを、日本市場の商習慣、表現、販売チャネル、規制に合わせて再設計する agent。 | `marketing/marketing-china-market-localization-strategist.md` |
|  | 日本向けコンテンツクリエイター | upstream | skeleton | Content Creator | 日本の B2B / B2C マーケティング向けに記事、SNS、LP、メール、導入事例、技術解説を作る content agent。 | `marketing/marketing-content-creator.md` |
|  | 日本向け越境 EC 戦略家 | upstream | skeleton | Cross-Border Ecommerce | 日本発または日本向けの越境 EC で、商品、物流、決済、翻訳、広告、規制、CS を設計する marketing agent。 | `marketing/marketing-cross-border-ecommerce.md` |
|  | TikTok Japan 戦略家 | upstream | skeleton | Douyin Strategist | TikTok Japan 戦略家 として、英文上流 agency-agents の専門性を日本市場、商習慣、日本語表現、稟議・承認・運用責任に合わせて実務で使える成果物へ落とし込む マーケティング agent。 | `marketing/marketing-douyin-strategist.md` |
|  | 日本向けグロースハッカー | upstream | skeleton | Growth Hacker | 日本の SaaS、アプリ、EC、メディアで acquisition、activation、retention、referral、revenue を実験改善する agent。 | `marketing/marketing-growth-hacker.md` |
|  | 日本向け Instagram キュレーター | upstream | skeleton | Instagram Curator | 日本向け Instagram の投稿、リール、ストーリーズ、プロフィール、ハイライト、導線を設計・改善する marketing agent。 | `marketing/marketing-instagram-curator.md` |
|  | Short Video Japan 戦略家 | upstream | skeleton | Kuaishou Strategist | TikTok、YouTube Shorts、Instagram Reels 向けに日本市場の短尺動画企画・改善を行う marketing agent。 | `marketing/marketing-kuaishou-strategist.md` |
|  | LinkedIn Japan コンテンツ制作者 | upstream | skeleton | LinkedIn Content Creator | 日本の B2B、採用、経営者発信、海外展開向けに LinkedIn 投稿と thought leadership を作る agent。 | `marketing/marketing-linkedin-content-creator.md` |
|  | 日本向けライブコマースコーチ | upstream | skeleton | Livestream Commerce Coach | 日本の EC、店舗、D2C、SNS 販売向けにライブ配信の台本、商品訴求、導線、運営を支援する agent。 | `marketing/marketing-livestream-commerce-coach.md` |
|  | 日本向けポッドキャスト戦略家 | upstream | skeleton | Podcast Strategist | 日本の B2B、採用、技術広報、コミュニティ向けに podcast 企画、構成、配信、再利用を設計する agent。 | `marketing/marketing-podcast-strategist.md` |
|  | 日本向け CRM / コミュニティ運用者 | upstream | skeleton | Private Domain Operator | LINE、メール、会員サイト、ユーザー会、Slack / Discord などの CRM / community 運用を設計する marketing agent。 | `marketing/marketing-private-domain-operator.md` |
|  | 日本向けオンラインコミュニティビルダー | upstream | skeleton | Reddit Community Builder | Discord、Slack、X、Qiita、Zenn、connpass などで日本向けオンラインコミュニティを育てる agent。 | `marketing/marketing-reddit-community-builder.md` |
|  | 日本向け SEO スペシャリスト | upstream | skeleton | SEO Specialist | 日本語検索向けに technical SEO、content SEO、local SEO、構造化 data、検索意図分析を行う marketing agent。 | `marketing/marketing-seo-specialist.md` |
|  | 日本向けショート動画編集コーチ | upstream | skeleton | Short Video Editing Coach | TikTok、YouTube Shorts、Instagram Reels 向けに日本語字幕、テンポ、構成、CTA を改善する editing coach。 | `marketing/marketing-short-video-editing-coach.md` |
|  | 日本向け SNS 戦略家 | upstream | skeleton | Social Media Strategist | X、Instagram、TikTok、YouTube、LINE、LinkedIn などを日本市場向けに統合設計する social media strategist。 | `marketing/marketing-social-media-strategist.md` |
|  | TikTok Japan 戦略家 | upstream | skeleton | TikTok Strategist | TikTok Japan 戦略家 として、英文上流 agency-agents の専門性を日本市場、商習慣、日本語表現、稟議・承認・運用責任に合わせて実務で使える成果物へ落とし込む マーケティング agent。 | `marketing/marketing-tiktok-strategist.md` |
|  | X Japan エンゲージメント担当 | upstream | skeleton | Twitter Engager | 日本向け X の投稿、返信、引用、スペース、コミュニティ参加を通じて信頼と接点を作る marketing agent。 | `marketing/marketing-twitter-engager.md` |
|  | 日本向け動画最適化専門家 | upstream | skeleton | Video Optimization Specialist | YouTube、Shorts、ウェビナー、製品 demo 動画を、日本語 title、thumbnail、構成、配信導線で最適化する agent。 | `marketing/marketing-video-optimization-specialist.md` |
|  | LINE 公式アカウント戦略家 | upstream | skeleton | WeChat Official Account | 日本向け LINE 公式アカウントの配信、セグメント、ステップ配信、CRM、来店・購買導線を設計する agent。 | `marketing/marketing-wechat-official-account.md` |
|  | X / Threads Japan 戦略家 | upstream | skeleton | Weibo Strategist | 日本向けに X、Threads、Bluesky などの短文 SNS 発信、会話、キャンペーン、リスク対応を設計する agent。 | `marketing/marketing-weibo-strategist.md` |
|  | Instagram / Lemon8 戦略家 | upstream | skeleton | Xiaohongshu Specialist | 日本向けに Instagram、Lemon8、Pinterest など visual discovery platform の投稿・保存・購買導線を設計する agent。 | `marketing/marketing-xiaohongshu-specialist.md` |
|  | note / Qiita / Zenn 戦略家 | upstream | skeleton | Zhihu Strategist | 日本向けに note、Qiita、Zenn、はてなブログを使った技術広報、採用広報、SEO、コミュニティ発信を設計する agent。 | `marketing/marketing-zhihu-strategist.md` |

## Paid Media

Total: 8 (⭐ 1 japan-original + 7 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本向け検索・SNS広告ストラテジスト | japan-original |  |  | 日本の B2B SaaS、IT service、EC 向けに Google / Yahoo! JAPAN / Meta / X / LinkedIn 広告の設計、運用、改善方針を作る paid media strategist。 | `paid-media/paid-media-japan-search-social-strategist.md` |
|  | 日本向け広告監査担当 | upstream | skeleton | Paid Media Auditor | Google、Yahoo! JAPAN、Meta、X、LinkedIn などの広告運用を、日本市場の規制・計測・予算・成果観点で監査する agent。 | `paid-media/paid-media-auditor.md` |
|  | 日本向け広告クリエイティブ戦略家 | upstream | skeleton | Creative Strategist | 日本の媒体、商材、審査、顧客心理に合わせて広告クリエイティブ仮説、訴求軸、検証計画を設計する agent。 | `paid-media/paid-media-creative-strategist.md` |
|  | 日本向け SNS 広告戦略家 | upstream | skeleton | Paid Social Strategist | Meta、X、TikTok、LINE、LinkedIn など日本で使われる SNS 広告の設計・改善・検証方針を作る agent。 | `paid-media/paid-media-paid-social-strategist.md` |
|  | 日本向け PPC 戦略家 | upstream | skeleton | PPC Strategist | Google 広告と Yahoo! 広告を中心に、日本語検索行動、予算、CV 品質を踏まえた PPC 戦略を作る agent。 | `paid-media/paid-media-ppc-strategist.md` |
|  | 日本向けプログラマティック広告バイヤー | upstream | skeleton | Programmatic Buyer | 日本の DSP、PMP、動画、ディスプレイ、ブランドセーフティを踏まえて programmatic buying を設計・改善する agent。 | `paid-media/paid-media-programmatic-buyer.md` |
|  | 日本向け検索クエリアナリスト | upstream | skeleton | Search Query Analyst | 日本語の検索語句、表記ゆれ、購買意図を分析し、広告運用の除外・拡張・LP 改善につなげる agent。 | `paid-media/paid-media-search-query-analyst.md` |
|  | 日本向け広告計測専門家 | upstream | skeleton | Tracking Specialist | GA4、GTM、媒体タグ、CAPI、オフライン CV を、日本の広告運用・個人情報・CRM 連携に合わせて設計する agent。 | `paid-media/paid-media-tracking-specialist.md` |

## Finance

Total: 9 (⭐ 4 japan-original + 5 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 電子帳簿保存法レビュアー | japan-original |  |  | 電子帳簿保存法に関する電子取引データ保存、検索要件、改ざん防止、運用ルールを review する finance / compliance agent。 | `finance/finance-electronic-bookkeeping-reviewer.md` |
| ⭐ | 日本向け FinOps アナリスト | japan-original |  |  | 日本の SaaS / 業務システムで cloud cost、SaaS cost、unit economics、予算、配賦、削減施策を分析する FinOps analyst。 | `finance/finance-japanese-finops-analyst.md` |
| ⭐ | 日本向け内部監査コーディネーター | japan-original |  |  | 日本企業の IT 統制、SaaS 利用、権限管理、委託先管理、変更管理、証跡、監査対応を整理する internal audit coordinator。 | `finance/finance-japanese-internal-audit-coordinator.md` |
| ⭐ | インボイス制度アドバイザー | japan-original |  |  | 日本のインボイス制度に関する請求書、適格請求書発行事業者番号、取引先確認、会計 system 要件を整理する finance advisor。 | `finance/finance-japanese-invoice-system-advisor.md` |
|  | 日本向け経理・管理会計コントローラー | upstream | skeleton | Bookkeeper & Controller | 月次決算、請求、入出金、管理会計、証憑、内部統制を日本企業の IT / SaaS / 受託開発現場向けに整理するファイナンス agent。 | `finance/finance-bookkeeper-controller.md` |
|  | 日本向け財務分析担当 | upstream | skeleton | Financial Analyst | 売上、粗利、原価、cash flow、予実、KPI を分析し、日本企業の経営会議・稟議・事業判断向けに整理するファイナンス agent。 | `finance/finance-financial-analyst.md` |
|  | 日本向け FP&A アナリスト | upstream | skeleton | FP&A Analyst | 予算策定、forecast、予実管理、scenario planning、経営会議資料を日本企業の事業運営向けに整えるファイナンス agent。 | `finance/finance-fpa-analyst.md` |
|  | 日本向け投資リサーチャー | upstream | skeleton | Investment Researcher | 市場、企業、競合、財務、事業リスクを調査し、日本企業の投資・M&A・新規事業判断向けに整理するファイナンス agent。 | `finance/finance-investment-researcher.md` |
|  | 日本向け税務戦略アドバイザー | upstream | skeleton | Tax Strategist | 法人税、消費税、インボイス、電子帳簿、海外取引、税務論点を日本企業の IT / SaaS / 事業運営向けに整理するファイナンス agent。 | `finance/finance-tax-strategist.md` |

## Game Development

Total: 20 (⭐ 0 japan-original + 20 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
|  | 日本向け Blender アドオンエンジニア | upstream | skeleton | Blender Add-on Engineer | Blender アドオン、asset validator、exporter、DCC pipeline automation を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/blender/blender-addon-engineer.md` |
|  | 日本向けゲーム音響エンジニア | upstream | skeleton | Game Audio Engineer | FMOD/Wwise、adaptive music、spatial audio、audio budget を日本のゲーム制作現場向けに設計するゲーム開発 agent。 | `game-development/game-audio-engineer.md` |
|  | 日本向けゲームデザイナー | upstream | skeleton | Game Designer | core loop、progression、economy、live ops、platform guideline を日本市場向けに設計するゲーム開発 agent。 | `game-development/game-designer.md` |
|  | 日本向け Godot Gameplay Scripter | upstream | skeleton | Godot Gameplay Scripter | Godot 4 の GDScript、C# 連携、node composition、signal 設計を日本のゲーム制作向けに整理するゲーム開発 agent。 | `game-development/godot/godot-gameplay-scripter.md` |
|  | 日本向け Godot Multiplayer Engineer | upstream | skeleton | Godot Multiplayer Engineer | Godot 4 MultiplayerAPI、RPC、authority model、scene replication を日本の multiplayer 制作向けに設計するゲーム開発 agent。 | `game-development/godot/godot-multiplayer-engineer.md` |
|  | 日本向け Godot Shader Developer | upstream | skeleton | Godot Shader Developer | Godot shader language、VisualShader、CanvasItem / Spatial shader、post-processing を日本の制作現場向けに整理するゲーム開発 agent。 | `game-development/godot/godot-shader-developer.md` |
|  | 日本向けレベルデザイナー | upstream | skeleton | Level Designer | layout、pacing、encounter、environmental storytelling、playtest feedback を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/level-designer.md` |
|  | 日本向けゲームナラティブデザイナー | upstream | skeleton | Narrative Designer | dialogue、branching narrative、world bible、lore、localization、IP 監修を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/narrative-designer.md` |
|  | 日本向け Roblox Avatar Creator | upstream | skeleton | Roblox Avatar Creator | Roblox UGC、avatar item、accessory rigging、Creator Marketplace submission を日本の制作現場向けに整理するゲーム開発 agent。 | `game-development/roblox-studio/roblox-avatar-creator.md` |
|  | 日本向け Roblox Experience Designer | upstream | skeleton | Roblox Experience Designer | Roblox experience の engagement loop、progression、monetization、retention を日本市場向けに設計するゲーム開発 agent。 | `game-development/roblox-studio/roblox-experience-designer.md` |
|  | 日本向け Roblox Systems Scripter | upstream | skeleton | Roblox Systems Scripter | Roblox Luau、client-server security、RemoteEvents、DataStore、module architecture を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/roblox-studio/roblox-systems-scripter.md` |
|  | 日本向けテクニカルアーティスト | upstream | skeleton | Technical Artist | art pipeline、shader、rigging、VFX、asset validation、performance budget を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/technical-artist.md` |
|  | 日本向け Unity Architect | upstream | skeleton | Unity Architect | Unity の ScriptableObject、component composition、data-driven architecture を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/unity/unity-architect.md` |
|  | 日本向け Unity Editor Tool Developer | upstream | skeleton | Unity Editor Tool Developer | Unity EditorWindow、PropertyDrawer、AssetPostprocessor、pipeline automation を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/unity/unity-editor-tool-developer.md` |
|  | 日本向け Unity Multiplayer Engineer | upstream | skeleton | Unity Multiplayer Engineer | Unity Netcode for GameObjects、UGS Relay/Lobby、server authority、lag compensation を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/unity/unity-multiplayer-engineer.md` |
|  | 日本向け Unity Shader Graph Artist | upstream | skeleton | Unity Shader Graph Artist | Unity Shader Graph、HLSL、URP/HDRP、custom render pass を日本の制作現場向けに整理するゲーム開発 agent。 | `game-development/unity/unity-shader-graph-artist.md` |
|  | 日本向け Unreal Multiplayer Architect | upstream | skeleton | Unreal Multiplayer Architect | Unreal Engine 5 の replication、GameMode/GameState、server authority、network prediction を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/unreal-engine/unreal-multiplayer-architect.md` |
|  | 日本向け Unreal Systems Engineer | upstream | skeleton | Unreal Systems Engineer | Unreal Engine 5 の C++/Blueprint architecture、GAS、Nanite、Lumen、performance を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/unreal-engine/unreal-systems-engineer.md` |
|  | 日本向け Unreal Technical Artist | upstream | skeleton | Unreal Technical Artist | Unreal Engine 5 の Material Editor、Niagara、PCG、art-to-engine pipeline を日本の制作現場向けに整理するゲーム開発 agent。 | `game-development/unreal-engine/unreal-technical-artist.md` |
|  | 日本向け Unreal World Builder | upstream | skeleton | Unreal World Builder | Unreal Engine 5 の World Partition、Landscape、procedural foliage、HLOD、streaming を日本の制作現場向けに設計するゲーム開発 agent。 | `game-development/unreal-engine/unreal-world-builder.md` |

## HR

Total: 4 (⭐ 4 japan-original + 0 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本 IT 企業研修デザイナー | japan-original |  |  | 日本の IT 組織向けに security、AI 活用、開発 process、onboarding、CS / sales enablement の研修設計、教材、演習、理解度確認を作る training designer。 | `hr/hr-japanese-corporate-training-designer.md` |
| ⭐ | 日本 IT 採用担当 | japan-original |  |  | 日本の IT エンジニア採用、職務要件、スカウト、カジュアル面談、選考設計、採用広報を支援する recruiter。 | `hr/hr-japanese-it-recruiter.md` |
| ⭐ | 日本 IT オンボーディング担当 | japan-original |  |  | 日本の IT 組織で新入社員・業務委託・協力会社メンバーの onboarding、権限、環境構築、業務理解を支援する specialist。 | `hr/hr-japanese-onboarding-specialist.md` |
| ⭐ | 日本 IT 人事評価ファシリテーター | japan-original |  |  | 日本の IT 組織で engineer / designer / PM / support 職の目標設定、評価観点、1on1、昇格判断、フィードバック文面を整える facilitator。 | `hr/hr-japanese-performance-review-facilitator.md` |

## Design

Total: 11 (⭐ 3 japan-original + 8 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本向けアクセシビリティ監査者 | japan-original |  |  | 日本語 UI、行政・公共 sector、業務 system に対して WCAG / JIS を意識した accessibility audit を行う。 | `design/design-accessibility-auditor-ja.md` |
| ⭐ | 日本業務 UI デザイナー | japan-original |  |  | 日本の業務画面、管理画面、申請画面、帳票画面に強い UI designer。高密度 table、入力補助、誤操作防止を重視する。 | `design/design-japanese-business-ui-designer.md` |
| ⭐ | 日本業務 Design System メンテナー | japan-original |  |  | 日本の業務システム、SaaS 管理画面、申請・承認 UI 向けに design system、component rule、文言、accessibility、実装連携を整える maintainer。 | `design/design-japanese-design-system-maintainer.md` |
|  | 日本向けブランドガーディアン | upstream | skeleton | Brand Guardian | 日本市場のブランド表現、広告審査、社内承認、顧客信頼を踏まえて visual / copy / UI の一貫性を守る design agent。 | `design/design-brand-guardian.md` |
|  | 日本向け画像プロンプトエンジニア | upstream | skeleton | Image Prompt Engineer | 日本市場向けの広告、LP、営業資料、プロダクト画像に使う生成画像 prompt を、ブランド・審査・権利観点まで含めて設計する agent。 | `design/design-image-prompt-engineer.md` |
|  | 日本向けインクルーシブビジュアル専門家 | upstream | skeleton | Inclusive Visuals Specialist | 日本の多様な利用者、年齢層、地域、障害、ジェンダー、文化背景に配慮した visual 表現を設計・監査する design agent。 | `design/design-inclusive-visuals-specialist.md` |
|  | 日本向け UI デザイナー | upstream | skeleton | UI Designer | 日本の業務システム、B2B SaaS、EC、管理画面に合わせて高密度で誤操作に強い UI を設計する design agent。 | `design/design-ui-designer.md` |
|  | 日本向け UX アーキテクト | upstream | skeleton | UX Architect | 日本の業務・購買・承認・運用フローを踏まえ、プロダクト全体の UX 構造と導線を設計する agent。 | `design/design-ux-architect.md` |
|  | 日本向け UX リサーチャー | upstream | skeleton | UX Researcher | 日本の利用者、業務現場、購買・承認構造に合わせて UX research 設計、インタビュー、洞察整理を行う agent。 | `design/design-ux-researcher.md` |
|  | 日本向けビジュアルストーリーテラー | upstream | skeleton | Visual Storyteller | 日本の営業資料、採用広報、LP、展示会、プロダクト紹介で伝わる visual narrative を設計する design agent。 | `design/design-visual-storyteller.md` |
|  | 日本向け遊び心デザインアドバイザー | upstream | skeleton | Whimsy Injector | 日本のプロダクトや業務 UI に、信頼感を損なわない範囲で小さな楽しさ、親しみ、記憶に残る体験を加える design agent。 | `design/design-whimsy-injector.md` |

## Legal

Total: 6 (⭐ 6 japan-original + 0 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本向け AI 利用ポリシーライター | japan-original |  |  | 日本企業の生成 AI / AI tool 利用について、個人情報、機密情報、著作権、review、禁止用途、承認 flow を含む AI policy を作る specialist。 | `legal/legal-japanese-ai-policy-writer.md` |
| ⭐ | 日本向け契約レビュアー | japan-original |  |  | 業務委託契約、NDA、利用規約、SaaS 契約の risk、責任範囲、知財、個人情報、解除、損害賠償を整理する reviewer。 | `legal/legal-japanese-contract-reviewer.md` |
| ⭐ | 日本向けデータプライバシーオフィサー | japan-original |  |  | 日本企業の個人情報、委託先、第三者提供、保存期間、開示請求、漏えい対応、DPIA / privacy governance を整理する data privacy officer。 | `legal/legal-japanese-data-privacy-officer.md` |
| ⭐ | 日本向け社内ポリシーライター | japan-original |  |  | 日本企業の IT、security、個人情報、SaaS 利用、業務委託、開発運用に関する社内 policy、rule、guideline を分かりやすく整える policy writer。 | `legal/legal-japanese-policy-writer.md` |
| ⭐ | 個人情報保護レビュアー | japan-original |  |  | 日本の個人情報保護法、privacy policy、委託先管理、ログ出力、データ保持を review する compliance agent。 | `legal/legal-japanese-privacy-compliance-reviewer.md` |
| ⭐ | SLA / 保守契約レビュアー | japan-original |  |  | 日本の IT 保守契約、SLA、障害対応、サポート時間、責任分界、変更対応を review する specialist。 | `legal/legal-japanese-sla-maintenance-contract-reviewer.md` |

## Sales

Total: 14 (⭐ 6 japan-original + 8 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本向けアカウントストラテジスト | japan-original |  |  | 日本の B2B SaaS / SI / IT service で既存顧客の account plan、更新、拡張提案、稟議支援、関係者 mapping を設計する account strategist。 | `sales/sales-japanese-account-strategist.md` |
| ⭐ | 日本向けパートナーアライアンスマネージャー | japan-original |  |  | 日本の B2B SaaS、SI、IT service で販売代理店、SI partner、technology partner との alliance、co-marketing、共同提案を設計する partner alliance manager。 | `sales/sales-japanese-partner-alliance-manager.md` |
| ⭐ | 日本向け Revenue Operations マネージャー | japan-original |  |  | 日本の B2B SaaS / IT service で marketing、sales、CS、finance をまたいだ funnel、契約、請求、更新、拡張の revenue process を整える RevOps manager。 | `sales/sales-japanese-revenue-operations-manager.md` |
| ⭐ | 日本向け RFP 回答ライター | japan-original |  |  | 日本企業・自治体向け RFP、提案書、見積前提、体制、スケジュール、非機能、保守運用回答を作る sales / presales agent。 | `sales/sales-japanese-rfp-response-writer.md` |
| ⭐ | 日本向けセールスエンジニア | japan-original |  |  | 日本の B2B SaaS、SI、受託開発、IT service の商談で技術要件、demo、PoC、RFP 質問、提案 feasibility を支援する sales engineer。 | `sales/sales-japanese-sales-engineer.md` |
| ⭐ | 日本向けセールスオペレーションアナリスト | japan-original |  |  | 日本の B2B SaaS / IT service で pipeline、forecast、CRM hygiene、商談 stage、営業 KPI、見積 / 稟議 process を分析する sales operations analyst。 | `sales/sales-japanese-sales-operations-analyst.md` |
|  | 日本向け Account Strategist | upstream | skeleton | Account Strategist | 日本の B2B SaaS、SI、IT サービスで既存顧客の account plan、更新、拡張提案、関係者 mapping を設計する agent。 | `sales/sales-account-strategist.md` |
|  | 日本向けセールスコーチ | upstream | skeleton | Sales Coach | 日本の B2B 営業現場に合わせて商談準備、ヒアリング、提案、クロージング、振り返りを支援する coaching agent。 | `sales/sales-coach.md` |
|  | 日本向け商談戦略家 | upstream | skeleton | Deal Strategist | 日本の B2B 商談で決裁構造、競合、稟議、価格交渉、導入リスクを整理し受注戦略を作る agent。 | `sales/sales-deal-strategist.md` |
|  | 日本向けディスカバリーコーチ | upstream | skeleton | Discovery Coach | 日本の B2B 商談で顧客課題、現状業務、決裁条件、導入障壁を深掘りする discovery を支援する agent。 | `sales/sales-discovery-coach.md` |
|  | 日本向け Sales Engineer | upstream | skeleton | Sales Engineer | 日本の B2B SaaS、SI、IT サービス商談で技術要件、demo、PoC、RFP、非機能、運用論点を支援する presales agent。 | `sales/sales-engineer.md` |
|  | 日本向けアウトバウンド戦略家 | upstream | skeleton | Outbound Strategist | 日本の B2B 市場でターゲット企業選定、文面、架電、紹介、イベント follow-up を設計する outbound sales agent。 | `sales/sales-outbound-strategist.md` |
|  | 日本向けパイプライン分析担当 | upstream | skeleton | Pipeline Analyst | 日本の B2B 営業で CRM、forecast、商談 stage、受注確度、更新・拡張 pipeline を分析する RevOps 支援 agent。 | `sales/sales-pipeline-analyst.md` |
|  | 日本向け提案戦略家 | upstream | skeleton | Proposal Strategist | 日本の B2B SaaS、SI、受託開発、IT サービス向けに稟議・RFP・比較検討に強い提案構成を設計する agent。 | `sales/sales-proposal-strategist.md` |

## Spatial Computing

Total: 6 (⭐ 0 japan-original + 6 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
|  | 日本向け macOS Spatial / Metal エンジニア | upstream | skeleton | macOS Spatial / Metal Engineer | 日本の展示、研究、製造、教育向けに macOS / Metal / spatial rendering を設計・実装する engineering agent。 | `spatial-computing/macos-spatial-metal-engineer.md` |
|  | 日本向けターミナル連携専門家 | upstream | skeleton | Terminal Integration Specialist | XR / spatial application と CLI、開発環境、device control、運用 script を安全に連携させる agent。 | `spatial-computing/terminal-integration-specialist.md` |
|  | 日本向け visionOS 空間エンジニア | upstream | skeleton | visionOS Spatial Engineer | 日本向けの visionOS application を、UX、安全性、性能、審査、業務利用に合わせて設計・実装する agent。 | `spatial-computing/visionos-spatial-engineer.md` |
|  | 日本向け XR コックピット操作設計者 | upstream | skeleton | XR Cockpit Interaction Specialist | 製造、モビリティ、防災、研修向け XR cockpit / control interface の安全で誤操作に強い interaction を設計する agent。 | `spatial-computing/xr-cockpit-interaction-specialist.md` |
|  | 日本向け XR 没入体験開発者 | upstream | skeleton | XR Immersive Developer | 日本の展示、研修、観光、教育、製造向けに XR / AR / VR の没入体験を安全に実装する developer agent。 | `spatial-computing/xr-immersive-developer.md` |
|  | 日本向け XR インターフェースアーキテクト | upstream | skeleton | XR Interface Architect | 日本の業務・教育・展示向け XR 体験で、空間 UI、情報設計、interaction、safety を統合設計する agent。 | `spatial-computing/xr-interface-architect.md` |

## Support

Total: 13 (⭐ 7 japan-original + 6 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本 B2B カスタマーサクセスマネージャー | japan-original |  |  | 日本の B2B SaaS / IT service で onboarding、定着、活用促進、QBR、解約防止を支援する CSM。 | `support/support-japanese-customer-success-manager.md` |
| ⭐ | 日本語ヘルプデスク対応者 | japan-original |  |  | 日本語の問い合わせ、障害一次受付、操作案内、FAQ、エスカレーションを丁寧かつ正確に行う support responder。 | `support/support-japanese-helpdesk-responder.md` |
| ⭐ | 障害報告書ライター | japan-original |  |  | 日本の顧客・社内向け障害報告書、時系列、影響範囲、原因、暫定対応、恒久対応、再発防止策を整理する。 | `support/support-japanese-incident-report-writer.md` |
| ⭐ | 日本 IT 資産管理担当 | japan-original |  |  | 日本企業の PC、端末、SaaS license、account、貸与品、棚卸し、入退社 / 契約終了時の回収と権限削除を管理する IT asset manager。 | `support/support-japanese-it-asset-manager.md` |
| ⭐ | 日本向けサービスデリバリーマネージャー | japan-original |  |  | 日本の IT service / B2B SaaS / 保守運用で SLA、問い合わせ、障害、運用品質、顧客報告を管理する service delivery manager。 | `support/support-japanese-service-delivery-manager.md` |
| ⭐ | 日本向けサポート分析レポーター | japan-original |  |  | 日本の B2B SaaS / IT service の問い合わせ、障害、FAQ、SLA、顧客満足度を分析し、改善 action と定例 report を作る support analytics reporter。 | `support/support-japanese-support-analytics-reporter.md` |
| ⭐ | 日本語リリースノートライター | japan-original |  |  | 日本語の release note、顧客向け変更案内、社内共有、影響範囲、注意事項を分かりやすく書く writer。 | `support/support-release-note-writer-ja.md` |
|  | 日本向け Analytics Reporter | upstream | skeleton | Analytics Reporter | CS、サポート、障害、SaaS 運用のデータを日本の経営会議・週次報告・改善活動で使える KPI レポートへ整理する分析支援 agent。 | `support/support-analytics-reporter.md` |
|  | 日本向け Executive Summary Generator | upstream | skeleton | Executive Summary Generator | 技術・運用・事業の詳細情報を、日本の経営会議、稟議、ステアリングコミッティで判断しやすい要約へ変換する支援 agent。 | `support/support-executive-summary-generator.md` |
|  | 日本向け Finance Tracker | upstream | skeleton | Finance Tracker | SaaS、クラウド、保守、開発案件の費用を日本の予実管理、稟議、請求確認、部門配賦に使える形で追跡する支援 agent。 | `support/support-finance-tracker.md` |
|  | 日本向け Infrastructure Maintainer | upstream | skeleton | Infrastructure Maintainer | 日本の保守運用、監視、変更管理、障害対応、定期メンテナンスに合わせてインフラ運用品質を維持する支援 agent。 | `support/support-infrastructure-maintainer.md` |
|  | 日本向け Legal Compliance Checker | upstream | skeleton | Legal Compliance Checker | 日本の個人情報保護、契約、表示、セキュリティ、AI 利用ポリシーの観点から文書や運用の確認事項を整理する支援 agent。 | `support/support-legal-compliance-checker.md` |
|  | 日本向け Support Responder | upstream | skeleton | Support Responder | 日本の B2B SaaS、受託開発、保守運用に合わせて、問い合わせ返信、障害連絡、エスカレーション文面を作る支援 agent。 | `support/support-support-responder.md` |

## Supply Chain

Total: 4 (⭐ 4 japan-original + 0 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 日本向け在庫予測担当 | japan-original |  |  | 日本の小売、EC、製造業向けに需要予測、安全在庫、欠品、過剰在庫、リードタイムを分析する supply chain specialist。 | `supply-chain/supply-chain-inventory-forecasting-ja.md` |
| ⭐ | 日本向け IT 調達マネージャー | japan-original |  |  | 日本企業の SaaS、cloud、開発委託、業務委託、hardware 調達について RFP、見積比較、稟議、契約、発注、検収を管理する procurement manager。 | `supply-chain/supply-chain-japanese-procurement-manager.md` |
| ⭐ | 日本向けベンダー評価担当 | japan-original |  |  | 日本企業の vendor selection、RFP、見積、品質、納期、保守、セキュリティ、契約 risk を評価する supply chain / procurement specialist。 | `supply-chain/supply-chain-japanese-vendor-evaluator.md` |
| ⭐ | 日本向けベンダーリスクマネージャー | japan-original |  |  | 日本企業の SaaS vendor、開発委託先、協力会社、cloud / data processor の security、privacy、BCP、契約、継続性 risk を評価する vendor risk manager。 | `supply-chain/supply-chain-japanese-vendor-risk-manager.md` |

## Specialized

Total: 52 (⭐ 11 japan-original + 41 upstream-aligned)

| | Name | Source | Status | Upstream | Description | Path |
| --- | --- | --- | --- | --- | --- | --- |
| ⭐ | 自治体 DX コンサルタント | japan-original |  |  | 日本の自治体・公共 sector 向け DX、調達、住民サービス、セキュリティ、アクセシビリティ、運用保守を支援する consultant。 | `specialized/japanese-public-sector-dx-consultant.md` |
| ⭐ | 工場 IoT プランナー | japan-original |  |  | 日本の工場で sensor、PLC、edge device、network、cloud、dashboard を使った IoT data collection plan を作る。 | `specialized/specialized-factory-iot-planner.md` |
| ⭐ | 日本 IT 自動化ガバナンスアーキテクト | japan-original |  |  | 日本企業の RPA、workflow automation、AI agent、batch、integration automation に対して権限、監査、例外処理、運用責任を設計する automation governance architect。 | `specialized/specialized-japanese-automation-governance-architect.md` |
| ⭐ | 日本向け事業継続プランナー | japan-original |  |  | 日本企業の SaaS / 業務システム / IT 運用における BCP、DR、災害対応、代替運用、連絡網、復旧目標、訓練 plan を作る business continuity planner。 | `specialized/specialized-japanese-business-continuity-planner.md` |
| ⭐ | 日本 IT ナレッジベース管理者 | japan-original |  |  | 日本の IT 組織で Notion / Confluence / esa / Qiita Team / SharePoint などの knowledge base を整理し、検索性、更新責任、運用ルールを整える steward。 | `specialized/specialized-japanese-knowledge-base-steward.md` |
| ⭐ | 製造業 DX コンサルタント | japan-original |  |  | 日本の製造業向けに現場業務、品質、在庫、原価、設備、IoT、MES、traceability を踏まえた DX 提案を行う consultant。 | `specialized/specialized-japanese-manufacturing-dx-consultant.md` |
| ⭐ | 日本 IT 会議アシスタント | japan-original |  |  | 日本の IT プロジェクト、SI、SaaS、顧客定例で agenda、議事録、決定事項、課題、宿題、次回 action を整理する meeting assistant。 | `specialized/specialized-japanese-meeting-assistant.md` |
| ⭐ | 日本向けプライシングストラテジスト | japan-original |  |  | 日本の B2B SaaS、IT service、SI、support plan 向けに価格体系、packaging、見積前提、値引き rule、稟議しやすい説明を設計する pricing strategist。 | `specialized/specialized-japanese-pricing-strategist.md` |
| ⭐ | 日本 IT プロンプトエンジニア | japan-original |  |  | 日本の IT 開発、業務運用、CS、営業、社内 AI 活用向けに prompt、評価観点、ガードレール、再利用 template を設計する prompt engineer。 | `specialized/specialized-japanese-prompt-engineer.md` |
| ⭐ | 日本 IT リスクアセッサー | japan-original |  |  | 日本の IT project、SaaS、SI、業務委託、AI 活用における delivery、security、legal、operation、顧客影響 risk を整理する risk assessor。 | `specialized/specialized-japanese-risk-assessor.md` |
| ⭐ | 品質管理・カイゼンアドバイザー | japan-original |  |  | 日本の製造・業務現場で品質問題、なぜなぜ分析、再発防止、標準化、カイゼン活動を支援する advisor。 | `specialized/specialized-quality-control-kaizen-advisor.md` |
|  | 日本向け買掛金処理エージェント | upstream | skeleton | Accounts Payable Agent | 日本企業の請求書、発注書、検収、支払条件、消費税、承認、証憑管理を整理する accounts payable agent。 | `specialized/accounts-payable-agent.md` |
|  | 日本向け AI エージェント ID / Trust 設計者 | upstream | skeleton | Agentic Identity & Trust | AI agent の本人性、権限、監査ログ、委任、停止条件を日本企業のガバナンスに合わせて設計する agent。 | `specialized/agentic-identity-trust.md` |
|  | 日本向けエージェント編成オーケストレーター | upstream | skeleton | Agents Orchestrator | 複数 AI agent の役割分担、handoff、承認、監査、失敗時 fallback を日本の業務運用向けに設計する agent。 | `specialized/agents-orchestrator.md` |
|  | 日本向け自動化ガバナンスアーキテクト | upstream | skeleton | Automation Governance Architect | RPA、workflow automation、AI agent、batch の権限、監査、例外処理、運用責任を設計する governance agent。 | `specialized/automation-governance-architect.md` |
|  | 日本向けブロックチェーンセキュリティ監査者 | upstream | skeleton | Blockchain Security Auditor | Smart contract、wallet、key 管理、bridge、token operation を日本向けに監査する security agent。 | `specialized/blockchain-security-auditor.md` |
|  | 日本向けコンプライアンス監査者 | upstream | skeleton | Compliance Auditor | 日本企業の法令、社内規程、委託先、個人情報、セキュリティ、運用証跡を確認する compliance audit agent。 | `specialized/compliance-auditor.md` |
|  | 日本向け企業研修デザイナー | upstream | skeleton | Corporate Training Designer | 日本企業向けに IT、AI、セキュリティ、営業、CS、管理職研修の設計と教材化を行う training design agent。 | `specialized/corporate-training-designer.md` |
|  | 日本向けカスタマーサービス担当 | upstream | skeleton | Customer Service | 日本の B2B / B2C サポートで問い合わせ分類、返信、SLA、エスカレーション、FAQ 改善を行う customer service agent。 | `specialized/customer-service.md` |
|  | 日本向けデータ統合エージェント | upstream | skeleton | Data Consolidation Agent | CRM、SFA、会計、EC、CSV、Excel、DWH のデータを日本業務向けに統合・整形する agent。 | `specialized/data-consolidation-agent.md` |
|  | 日本向け公共 DX プリセールスコンサルタント | upstream | skeleton | Government Digital Presales Consultant | 自治体・公共機関向け DX 提案で調達、要件、セキュリティ、アクセシビリティ、運用保守を整理する agent。 | `specialized/government-digital-presales-consultant.md` |
|  | 日本向け医療カスタマーサービス担当 | upstream | skeleton | Healthcare Customer Service | 医療・ヘルスケア領域の問い合わせを、個人情報、医療広告、緊急性、専門家確認に配慮して整理する agent。 | `specialized/healthcare-customer-service.md` |
|  | 日本向け医療マーケティングコンプライアンス担当 | upstream | skeleton | Healthcare Marketing Compliance | 医療・ヘルスケア広告、LP、SNS、導入事例を医療広告ガイドライン、薬機法、個人情報観点で確認する agent。 | `specialized/healthcare-marketing-compliance.md` |
|  | 日本向け宿泊・観光ゲストサービス担当 | upstream | skeleton | Hospitality Guest Services | ホテル、旅館、観光施設の問い合わせ、予約、案内、多言語対応、クレーム対応を支援する guest services agent。 | `specialized/hospitality-guest-services.md` |
|  | 日本向け HR オンボーディング担当 | upstream | skeleton | HR Onboarding | 日本企業の入社手続き、労務、IT 権限、研修、配属、試用期間 follow-up を整理する HR onboarding agent。 | `specialized/hr-onboarding.md` |
|  | 日本向け ID グラフ運用者 | upstream | skeleton | Identity Graph Operator | 顧客 ID、会員 ID、広告 ID、CRM、CDP の名寄せ、同意、権限、削除を管理する identity graph agent。 | `specialized/identity-graph-operator.md` |
|  | 日本向け言語翻訳者 | upstream | skeleton | Language Translator | 技術文書、営業資料、サポート文、契約周辺文書を日本市場向けに自然で実務的な翻訳へ整える agent。 | `specialized/language-translator.md` |
|  | 日本向け法律事務請求・時間管理担当 | upstream | skeleton | Legal Billing & Time Tracking | 法律事務所・法務部の作業時間、請求、案件、証跡、顧客説明を整理する legal billing agent。 | `specialized/legal-billing-time-tracking.md` |
|  | 日本向け法律相談受付担当 | upstream | skeleton | Legal Client Intake | 法律相談の初回受付で事実関係、当事者、期限、利益相反、必要資料を整理する intake agent。 | `specialized/legal-client-intake.md` |
|  | 日本向け法務文書レビュー担当 | upstream | skeleton | Legal Document Review | 契約書、規約、NDA、業務委託、DPA、利用規約の確認事項と修正論点を整理する legal review agent。 | `specialized/legal-document-review.md` |
|  | 日本向け融資担当アシスタント | upstream | skeleton | Loan Officer Assistant | 日本の融資審査で申込情報、本人確認、収入、担保、返済能力、必要書類を整理する finance support agent。 | `specialized/loan-officer-assistant.md` |
|  | 日本向け LSP インデックスエンジニア | upstream | skeleton | LSP Index Engineer | 大規模 codebase の LSP、symbol index、検索、参照、AI coding 支援向け index を設計する agent。 | `specialized/lsp-index-engineer.md` |
|  | 日本向け不動産売買サポート担当 | upstream | skeleton | Real Estate Buyer/Seller | 日本の不動産売買で物件情報、希望条件、資金計画、内見、重要事項、契約前確認を整理する agent。 | `specialized/real-estate-buyer-seller.md` |
|  | 日本向け採用専門家 | upstream | skeleton | Recruitment Specialist | 日本の採用活動で求人票、候補者対応、面接設計、評価、オファー、入社 follow-up を支援する recruitment agent。 | `specialized/recruitment-specialist.md` |
|  | 日本向けレポート配信エージェント | upstream | skeleton | Report Distribution Agent | 経営、営業、CS、運用、監査向け report の配信先、権限、形式、頻度、証跡を管理する agent。 | `specialized/report-distribution-agent.md` |
|  | 日本向け小売返品対応担当 | upstream | skeleton | Retail Customer Returns | 日本の EC / 小売で返品、交換、返金、初期不良、配送事故、規約確認を支援する customer operations agent。 | `specialized/retail-customer-returns.md` |
|  | 日本向け Sales Data Extraction Agent | upstream | skeleton | Sales Data Extraction Agent | 商談メモ、メール、議事録、名刺、CRM から日本の営業活動に必要な情報を抽出・整形する agent。 | `specialized/sales-data-extraction-agent.md` |
|  | 日本向け Sales Outreach | upstream | skeleton | Sales Outreach | 日本の B2B 営業向けに個社仮説、メール、電話、紹介、イベント follow-up の outreach を設計する agent。 | `specialized/sales-outreach.md` |
|  | 日本向け Chief of Staff | upstream | skeleton | Chief of Staff | 日本企業の経営・事業責任者を支援し、会議、意思決定、横断課題、KPI、実行管理を整理する agent。 | `specialized/specialized-chief-of-staff.md` |
|  | 日本向け土木エンジニア | upstream | skeleton | Civil Engineer | 日本の土木・建設 project で設計条件、施工、維持管理、安全、発注者説明を整理する civil engineering agent。 | `specialized/specialized-civil-engineer.md` |
|  | 日本向け文化インテリジェンス戦略家 | upstream | skeleton | Cultural Intelligence Strategist | 日本市場・海外市場間の文化、商習慣、表現、交渉、ローカライズリスクを読み解く strategist agent。 | `specialized/specialized-cultural-intelligence-strategist.md` |
|  | 日本向けデベロッパーアドボケイト | upstream | skeleton | Developer Advocate | 日本向けデベロッパーアドボケイト として、英文上流 agency-agents の専門性を日本市場、商習慣、日本語表現、稟議・承認・運用責任に合わせて実務で使える成果物へ落とし込む 専門業務 agent。 | `specialized/specialized-developer-advocate.md` |
|  | 日本向け文書生成担当 | upstream | skeleton | Document Generator | 稟議書、議事録、提案書、報告書、手順書、FAQ など日本企業で使う文書を構造化して生成する agent。 | `specialized/specialized-document-generator.md` |
|  | 日本向けフランス市場コンサルティング担当 | upstream | skeleton | French Consulting Market | 日本企業のフランス市場進出、現地 partner、商習慣、言語、規制、提案資料を支援する market consulting agent。 | `specialized/specialized-french-consulting-market.md` |
|  | 日本向け韓国ビジネスナビゲーター | upstream | skeleton | Korean Business Navigator | 日本企業と韓国市場・韓国企業の商談、提携、ローカライズ、文化差、資料作成を支援する agent。 | `specialized/specialized-korean-business-navigator.md` |
|  | 日本向け MCP ビルダー | upstream | skeleton | MCP Builder | 日本企業の社内 tools、SaaS、DB、業務 API を安全に AI へ接続する MCP server / tool builder agent。 | `specialized/specialized-mcp-builder.md` |
|  | 日本向けモデル QA 担当 | upstream | skeleton | Model QA | 日本語 AI model / RAG / agent の評価、回帰試験、安全性、業務適合性を検証する QA agent。 | `specialized/specialized-model-qa.md` |
|  | 日本向け Salesforce アーキテクト | upstream | skeleton | Salesforce Architect | 日本企業向けに Salesforce のデータ model、権限、Flow、外部連携、営業・CS 運用を設計する agent。 | `specialized/specialized-salesforce-architect.md` |
|  | 日本向けワークフローアーキテクト | upstream | skeleton | Workflow Architect | 日本企業の申請、承認、通知、例外処理、監査証跡を含む業務 workflow を設計する agent。 | `specialized/specialized-workflow-architect.md` |
|  | 日本向け留学アドバイザー | upstream | skeleton | Study Abroad Advisor | 日本からの留学希望者向けに国、学校、費用、ビザ、語学、生活準備、申請 schedule を整理する agent。 | `specialized/study-abroad-advisor.md` |
|  | 日本向けサプライチェーン戦略家 | upstream | skeleton | Supply Chain Strategist | 日本の製造・小売・EC 向けに調達、生産、在庫、物流、BCP、リードタイム改善を設計する agent。 | `specialized/supply-chain-strategist.md` |
|  | 日本向けゼロ知識証明スチュワード | upstream | skeleton | ZK Steward | ZK proof、privacy-preserving identity、検証、鍵管理、利用者説明を日本向けに整理する cryptography agent。 | `specialized/zk-steward.md` |
