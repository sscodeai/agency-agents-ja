# Hermes Integration

`agency-agents-ja` を Hermes 向けの lazy-router plugin として変換します。

通常の per-agent skill として 300 件以上を起動時に読み込ませるのではなく、`agency-agents-router` plugin ひとつを install し、agent roster は `data/agents.json` として disk 上に保持します。Hermes からは検索、inspect、load、delegate の小さな tool surface だけを見せ、必要な specialist agent だけを遅延 load します。

## Generate

```bash
./scripts/convert.sh --tool hermes
```

生成先:

```text
integrations/hermes/agency-agents-router/
```

## Install

```bash
./scripts/install.sh --tool hermes
```

既定では次へ copy します:

```text
${HERMES_HOME:-~/.hermes}/plugins/agency-agents-router
```

`HERMES_PLUGIN_DIR` を指定すると install 先を上書きできます。

## Hermes での使い方

Project instruction には次のように書きます:

```text
Use the agency-agents-router plugin. Search the agency-agents-ja roster for the right specialists, then load or delegate only the specific agents needed for each part of the project. Do not preload the full roster.
```

## Exposed Tools

- `agency_agents_search` — query と division で specialist を探す
- `agency_agents_inspect` — agent metadata または full body を確認する
- `agency_agents_load` — 選んだ agent の prompt block を現在 task 用に構成する
- `agency_agents_delegate` — Hermes の `delegate_task` が使える場合に specialist へ委譲する
