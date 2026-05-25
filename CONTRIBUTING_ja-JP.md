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
