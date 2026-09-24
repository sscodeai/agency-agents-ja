# Evaluation Fixtures

このディレクトリは、agent の振る舞いを確認するための評価用 fixture を置きます。

agent 本体は「どの役割として、何を成果物にするか」を定義します。eval はその上で、「根拠のない数値を出していないか」「未確認事項を `UNKNOWN` として残せるか」「規制や platform の仕様を断定していないか」を確認します。agent 本文を書き換えた PR では、この fixture で前後の応答を比較してください。

## 目的

- 修正の前後で、agent が evidence に基づいて答えるかを比較する
- 誇大表現、捏造した数値、規制上の断定など、レビューで見落としやすい逸脱を検出する
- `SEARCH-GROWTH-STACK.md` の Evidence Protocol（`VERIFIED` / `PROVIDED` / `OBSERVED` / `INFERRED` / `HYPOTHESIS` / `UNKNOWN`）が実際に守られているか確認する

## 構成

| Fixture | 対象 agent | 主に確認する観点 |
| --- | --- | --- |
| `evals/marketing/aeo-foundations-v2.md` | `marketing/marketing-aeo-foundations.md` | crawler 種別、discovery file、token 上限、structured data を断定しない |
| `evals/marketing/seo-specialist-v2.md` | `marketing/marketing-seo-specialist.md` | 数値の捏造、keyword density などの古い通説、因果の早合点 |
| `evals/marketing/ai-citation-strategist-v2.md` | `marketing/marketing-ai-citation-strategist.md` | AI citation の測定理論、単発結果の一般化、benchmark の捏造 |

## 実行方法

人手、または agent 実行環境で、各 `## Case` の `**User:**` をそのまま入力し、`**Pass conditions:**` を満たすか確認します。同じ Case を修正前後の agent（または prompt）で実行し、差分を PR に残してください。

構造と参照 path は script で検証できます。

```bash
npm run check:evals
```

## 判定

- 満たした pass condition を 1 点として数える
- `**Critical failure:**` または `## Critical failures` に該当した場合、点数に関係なく fail
- 「断定しないこと」自体を pass condition にしているため、判断を保留して確認先を提示できていれば合格です

## Fixture の追加

1. `evals/<division>/<agent-slug>-v<version>.md` として作成する
2. `対象 agent:` 行に対象 agent の repo 内 path を backtick で書く（存在しない path は `npm run check:evals` が検出します）
3. `# タイトル`、`## Purpose`、`## Case N — 説明`（3 件以上、各 Case に `**Pass conditions:**`）、`## Scoring` を含める
4. 先頭に YAML frontmatter を置かない（fixture は agent ではなく、agent 数を数える対象ではないため）
5. `npm run check:evals` と `npm run validate` を実行する
