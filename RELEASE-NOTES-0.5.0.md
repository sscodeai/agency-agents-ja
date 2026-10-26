# agency-agents-ja v0.5.0 リリースノート

リリース日: 2026-10-26

## 概要

v0.5.0 は、エージェントカタログの拡張、19 個目の統合先の追加、そしてインストール・変換・リリース周りの信頼性向上をまとめたリリースです。

| 項目 | v0.4.0 | v0.5.0 |
| --- | ---: | ---: |
| エージェント数 | 385 | **411** |
| 日本市場オリジナル | 115 | **128** |
| 上流由来（adapted） | 270 | **283** |
| 対応ツール | 16 | **19** |
| ワークフロー | 27 | 27 |
| scripts | 21 | **55** |
| 上流ベースライン | `ebe9c99`（2026-08-08） | `b37b5bb`（2026-10-24） |

v0.4.0 以降のコミット数は **93**（fix 23 / feat 20 / docs 15 / chore 8 / test 7 / ci 2）です。

## v0.4.0（2026-08-13）のおさらい

- カタログを **385 エージェント**（日本オリジナル 115 / 上流由来 270）へ拡張
- `gis/` と `healthcare/` の 2 部門を追加
- Economy Designer、Privacy Engineer、LLM Post-Training、Data Visualization、UI Finish-Gate、Rust Refactoring、RAG Pipeline、GaussDB、適時開示 などの役割を追加
- Codex / Osaurus / Hermes / Mistral Vibe / ZCode の統合を追加
- 生成物、部門・ツール・runbook、workflow YAML、package files、`npm test` によるリリース検証を強化
- 選択インストール、パス上書き、決定的な生成物、古い統合の検出など install / convert を改善

## v0.5.0 の変更

### 1. エージェントカタログ（+26）

**Company（7）**
- 日本向け CEO / CFO / CMO / COO / CPO / CTO アドバイザー
- 日本向け Chief of Staff / 経営企画補佐

**Engineering（10）**
- ServiceNow 開発者メンター
- 日本向け電気設備エンジニア
- 日本向け組込みアルゴリズムエンジニア / 組込みアプリケーションエンジニア
- 日本向けナレッジグラフエンジニア / プラットフォームエンジニア
- 日本向け PDF Engine Architect / Universal Document Compiler
- 日本向け ATS Validator Architect / China Network Engineer

**Specialized（4）**
- 日本向け旅行プランナー
- 日本向け鑑定・真贋評価アドバイザー
- 日本向け Focus Music Architect
- 日本向け Master Plan Architect

**Marketing（2）**
- デベロッパーコミュニティビルダー
- Search Growth Orchestrator

**Product / Design / Research（各 1）**
- プロダクト DX エンジニア
- 日本向け動画プロンプトエンジニア
- 日本向けリサーチシンセシスト

また、表示名が重複していた 3 組を整理しました。

- Baidu 由来の SEO エージェント → **テクニカル SEO スペシャリスト**
- Douyin 由来のエージェント → **TikTok LIVE コマース ストラテジスト**
- 上流の developer advocate → **デベロッパーエクスペリエンス / DevEx スペシャリスト**

### 2. 統合と互換性

- **DeepSeek Harness（dsh）** を 19 個目の統合先として追加
  - `integrations/dsh/agency-<slug>/SKILL.md` を生成
  - `${DSH_HOME:-~/.dsh}/skills` または `DSH_SKILLS_DIR` にインストール
- **Hermes インストーラを修正**
  - 実際に `agency-agents-router` が有効化されるように修正
  - 行内コメント付きの設定項目、`disabled:` の残存、`[]` / `[a,b]`、末尾コメントを処理
  - 既存の無関係なディレクトリを置き換えないよう保護
- **Qwen Code 0.25.1 以上**を要求
  - 起動時に置換される `${task_prompt}` / `${hook_context}` / `${external_inputs_override}` を lint で拒否
- Aider / Windsurf の生成物を `600` から `644` に修正し、`--out` 時のログを実際のパスに修正
- CLI の未知オプションを終了コード 1 にし、`--help` を全オプション表示に修正

### 3. インストール / 変換の堅牢化

- 1 つのツールが失敗しても後続のツールを継続し、`Installed N of M` と失敗ツール名を表示して終了コード 1
- 自動変換が失敗した場合、中途半端な生成物を削除して再試行可能に
- 並列変換・並列インストールの失敗をログごと表示し、非ゼロで終了
- 重複するエージェント slug と、シンボリックリンクの出力ディレクトリを拒否
- `--path` の衝突エラーで、競合している 2 つのツール名を表示
- コードフェンスの解析を CommonMark / GitHub に合わせて修正（最大 3 スペースのインデント、info string 付きは閉じない）
- OpenClaw の SOUL.md / AGENTS.md 分割でフェンスが壊れないことを検証
- SIGPIPE、Hermes の末尾スラッシュ、共有パスの上書きなどの細かい不具合を修正

### 4. 検証 / CI / リリース

- `check-duplicate-names` を追加（表示名の重複を検出）
- `check-agent-originality` を追加（実体を置換しただけの重複を検出。20% で警告、40% で失敗）
- runbook のデプロイ可能性チェックを追加
- lint を強化
  - 閉じ `---` の欠落
  - folded YAML
  - 必須フィールドの空値
  - 同長のネストしたフェンス（実際の行番号付き）
  - ファイル末尾まで閉じられていないフェンス
  - Qwen の起動プレースホルダー
- lint の警告を **1207 件から 3 件**へ削減（残りはすべて実際の問題）
- 20 本以上の回帰テストを追加
  - フェンス、frontmatter、並列変換失敗、インストール継続、Hermes の出力先、`--path` 衝突など
- リリースを強化
  - `check:package` で tarball を実際に pack / install し、411 個の本文が逐語一致することを検証
  - `v*` タグと `package.json` のバージョン不一致を検出

### 5. ドキュメントとベースライン

- README / CONTRIBUTING / CHANGELOG を更新
- 上流ベースラインを `msitarzewski/agency-agents@b37b5bb`（2026-10-24）へ更新
- 上流の content-fix バッチは、日本語版の本文と逐語一致しないため対象外と判断

## アップグレード時の注意

- **Qwen Code は 0.25.1 以上**を使用してください。以前のバージョンでは、コード例に `${…}` を含むエージェントを起動できません。
- **Hermes** を利用している場合は、インストーラの挙動が変わっています。既存の設定ファイルは書き換え前にバックアップしてください。
- 表示名を変更した 3 エージェント（テクニカル SEO / TikTok LIVE コマース / DevEx）は、表示名でエージェントを登録するホストで名前が変わります。
- 既存の統合を利用している場合は、`./scripts/convert.sh` で生成物を再作成してから再インストールしてください。
- DeepSeek Harness を利用する場合は `./scripts/install.sh --tool dsh` を実行してください。

## 検証

- `npm run prepack`
- `npm run validate`
- `npm run check:package`
- `npm run check:upstream-parity`（283 / 283）
- `scripts/lint-agents.sh`（0 errors / 3 warnings）
- `scripts/check-agent-originality.sh`（0 failures）
