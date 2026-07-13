# ZCode Integration

[ZCode](https://z.ai) は Z.ai の GLM ベースのコーディングエージェント環境です。
agency-agents-ja の各エージェントは、`name` と `description` の YAML
frontmatter を持つ独立した Markdown agent file として出力されます。

生成ファイルは `scripts/convert.sh --tool zcode` から作成され、
`integrations/zcode/agents/` に 1 agent 1 file で配置されます。これらの
生成済み agent file は commit しません。必要に応じてローカルで再生成してください。

## Generate

Repository root から実行します。

```bash
./scripts/convert.sh --tool zcode
```

## Install

インストール先にしたい project directory から実行します。

```bash
cd /your/project && /path/to/agency-agents-ja/scripts/install.sh --tool zcode
```

既定では user scope の `~/.zcode/agents/<slug>.md` にインストールします。
project scope に入れる場合は `ZCODE_AGENTS_DIR=.zcode/agents` を指定してください。
