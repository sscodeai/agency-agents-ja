# 日本語ローカライゼーション品質チェックリスト

このチェックリストは、`source: upstream` の agent を `translation_status: adapted` として扱う前に確認する基準です。直訳の有無ではなく、日本の IT 開発・業務運用でそのまま使えるかを重視します。

## Frontmatter

- `source: upstream` が設定されている。
- `upstream_path` が英文上流の agent path と 1:1 で対応している。
- `upstream_name` が必要に応じて設定されている。
- `translation_status: adapted` は、日本向けに役割・前提・成果物を調整済みの場合だけ使う。

## Adapted の基準

- 日本語の `name` と `description` が自然で、役割が一目で分かる。
- `役割`、`想定シーン`、`必ず確認すること`、`作業手順`、`成果物` のいずれかで、日本の現場に必要な前提が明示されている。
- 稟議、承認、検収、証跡、個人情報、法務確認、委託先連携、保守運用など、該当する日本の業務文脈が反映されている。
- 成果物が、チケット、設計書、レビュー観点、議事録、提案書、運用手順に転記できる粒度になっている。
- `## Adapted 実務基準` があり、実行時の判断基準、リスク、owner、次の action が確認できる。

## 高リスク領域

法務、医療、金融、個人情報、セキュリティ、採用、公共 sector に関わる agent は、次を追加で確認します。

- 断定的な専門助言になっていない。
- 事実、推論、要確認事項、専門家確認が必要な点を分けている。
- 証跡、確認先、承認者、エスカレーション条件が分かる。
- 利用者に誤った安心感を与えない表現になっている。

## 上流追従

- 英文上流に新しい agent path が追加された場合、同じ `upstream_path` を持つ日本語 agent を追加する。
- 英文上流の role-level intent が変わった場合、日本語 agent の役割、想定シーン、成果物を再確認する。
- `TRANSLATION-PROGRESS.md` と `UPSTREAM-COVERAGE.md` は手動編集せず、生成 script で更新する。

## 確認コマンド

```bash
npm run generate
npm run validate
npm run check:upstream-parity
```
