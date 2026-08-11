# agency-agents-ja への貢献

`agency-agents-ja` を改善してくださりありがとうございます。この repository は [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) の日本語・日本市場向け community edition です。

## 貢献できること

- 上流対応 agent の skeleton を完全翻訳へ進める
- 日本市場向け original agent を追加する
- 日本の SIer、SaaS、EC、製造業 DX、公共 sector、compliance、運用現場に合わせて既存 agent を改善する
- workflow、example、integration document を日本語利用者向けに整える
- 上流 `main` との差分を確認し、coverage を更新する

## Agent の種類

### Japan-original

上流に対応する agent がなく、日本市場向けに独自設計した agent です。

```yaml
source: japan-original
```

### Upstream-aligned

上流 repository の file に対応する agent です。必ず `upstream_path` と `translation_status` を保持してください。

```yaml
source: upstream
upstream_path: engineering/example-agent.md
upstream_name: Example Agent
translation_status: skeleton
```

`translation_status` の意味:

- `skeleton`: 日本 context の骨格はあるが、上流 prompt の完全翻訳ではない
- `translated`: 上流 prompt の意図を保って完全翻訳済み
- `adapted`: 翻訳後、日本市場・商習慣・運用に合わせて意図的に適応済み

## Frontmatter

すべての agent file は YAML frontmatter を持つ必要があります。

```yaml
---
name: 日本語名
description: 呼び出す場面、専門性、成果物
emoji: 🧩
color: blue
source: japan-original
---
```

上流対応 agent の場合:

```yaml
---
name: 日本語名
description: 日本語での専門性と利用場面
emoji: 🧩
color: blue
source: upstream
upstream_path: engineering/example-agent.md
upstream_name: Example Agent
translation_status: skeleton
---
```

## 推奨本文構成

```markdown
# 日本語名

## 役割
## 想定シーン
## 必ず確認すること
## 作業手順
## 成果物
## 日本の現場での注意点
## 出力フォーマット
```

## 日本語化・本土化の方針

- 単なる直訳ではなく、日本の意思決定、稟議、検収、保守運用、顧客説明を想定する
- Backlog / Redmine / Jira / GitHub issue に転記できる粒度にする
- 個人情報、契約、著作権、platform policy、監査証跡を必要に応じて明示する
- 日本語の表記ゆれ、敬語、固有名詞、外来語の扱いを揃える
- 上流の role concept は保持し、勝手に別 role へ変えない

## 内容の red line

以下に該当する PR は、修正依頼または close の対象になります。

### 1. 特定の雇用主・会社 brand に agent を紐づけない

agent は「役割、方法論、実務上の振る舞い」を定義するものです。特定企業の社員 profile や採用広報のような書き方にはしないでください。

避ける例:

```markdown
あなたは ExampleCorp に所属する XX エンジニアです。ExampleCorp は XX 領域の leading company で...
- 役割: ExampleCorp 所属の XX エンジニア
```

望ましい例:

```markdown
あなたは XX 領域の複数 project に携わってきた実務家です...
- 役割: XX の方法論と実装・運用に集中するエンジニア
```

kintone、LINE WORKS、AWS、ISO 27001、特定 device family など、domain context として必要な product / platform / 標準 / protocol の言及は問題ありません。問題になるのは、技術的必然性のない宣伝的な identity や brand placement です。

### 2. agent prompt に第三者 tool の API / plugin 説明を埋め込まない

agent prompt は、任意の LLM や tool 環境で読まれる前提です。本文に特定 tool の API 名、plugin の呼び出し手順、外部 link、tracking link、宣伝文を埋め込まないでください。

避ける例:

```markdown
### Example Tool 連携
xxx-plugin が入っている場合は `tool_explore` を呼び、次に `tool_read` を使って...
```

tool 固有の説明は、この repository で保守する場合は `integrations/`、example、または独立した利用 guide に置いてください。agent 本文は specialist role と実務判断に集中させます。

### 3. docs / localization PR を soft promotion に使わない

「docs 更新」「翻訳」「軽微な修正」という PR title でも、実際の差分が sponsor link、SEO anchor text、vendor copy、無関係な product mention の追加であれば red line として扱います。PR title ではなく、変更内容そのものを見て判断します。

## Workflow と Example

Workflow YAML は `workflows/` に置きます。

Example markdown は `examples/` に置き、対応する workflow YAML と同期した YAML code block を含めてください。

## 生成と検証

変更後は以下を実行してください。

```bash
npm run generate
npm run validate
```

直接実行する場合:

```bash
node scripts/generate-agent-list.js
node scripts/generate-translation-progress.js
node scripts/check-upstream-coverage.js
./scripts/validate.sh
```

## Pull Request

PR には以下を含めてください。

- 何を追加・変更したか
- upstream 対応 agent か、Japan-original か
- `translation_status` を変更した場合は理由
- 実行した検証コマンド
- 未完了の翻訳や follow-up がある場合は明記
