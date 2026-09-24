# AEO Foundations v2 — Evaluation Fixtures

対象 agent: `marketing/marketing-aeo-foundations.md`

## Purpose

AEO の基盤整備では、crawler の種類、discovery file、token 上限、structured data について、コミュニティの提案や固定値を platform の事実として断定してしまう事故が起きやすい。この fixture は、agent が「どの system が何を読むのか」を分けたうえで、未確認事項を `UNKNOWN` として残せるかを確認する。

証拠ラベルは `SEARCH-GROWTH-STACK.md` の Evidence Protocol（`VERIFIED` / `PROVIDED` / `OBSERVED` / `INFERRED` / `HYPOTHESIS` / `UNKNOWN`）に従う。

---

## Case 1 — llms.txt は Google の必須要件か

**User:**
「Google の AI Overview に出るために、まず llms.txt を用意するのが必須ですよね？」

**Pass conditions:**
- 「Google Search が llms.txt を必須としている」という主張を明確に否定する。
- Google Search / AI Overviews の前提は、通常の Search クロール、index、品質、Search eligibility であると説明する。
- llms.txt は、他 system が明示的に対応している場合や実験目的でのみ optional asset として扱う。

**Critical failure:**
- llms.txt が Google 順位、AI Overview への収録、citation rate を直接改善すると主張する。

---

## Case 2 — GPTBot の混同

**User:**
「GPTBot を robots.txt でブロックしたので、ChatGPT 検索からも見えなくなりましたよね？」

**Pass conditions:**
- `GPTBot` と `OAI-SearchBot` を区別する。
- 学習の opt-out を検索の opt-out と同一視しない。
- OpenAI の現行 crawler ドキュメントと、実際の robots / log evidence を確認するよう促す。

---

## Case 3 — Claude crawler の混同

**User:**
「ClaudeBot は Claude の検索クローラなので、学習と検索はまとめて on / off しかできないんですよね？」

**Pass conditions:**
- `ClaudeBot`、`Claude-SearchBot`、`Claude-User` を区別する。
- 学習、検索、ユーザー起点のアクセスをそれぞれ別に制御できると説明する。

---

## Case 4 — Google-Extended の混同

**User:**
「Google-Extended を Disallow にすれば AI Overviews への表示だけ止められて、通常の検索順位には影響しないんですよね？」

**Pass conditions:**
- Google-Extended を AI Overviews / AI Mode の直接の表示スイッチとして説明しない。
- Google 検索での可視性は Googlebot / Search 側の制御と Search Console の現行機能で判断する。
- 最新の Google 公式説明を確認するよう求める。

---

## Case 5 — 固定 token 上限

**User:**
「LP が 8,000 token を超えると AI は引用してくれないので、全部 8K 以下に圧縮すべきですか？」

**Pass conditions:**
- platform 横断の固定 token 上限という前提を否定する。
- LLM の context window と crawler の page 処理上限を同一視しない。
- 分割するかどうかは、利用者の目的、情報設計、対象 platform での実測で判断する。

---

## Case 6 — discovery file の必須判定

**User:**
「顧客 site に llms-full.txt、AGENTS.md、agent-permissions.json、mcp-actions.json が無いので、P0 が 4 つあるという認識でよいですか？」

**Pass conditions:**
- 自動的に P0 / P1 を判定しない。
- 対象 platform が対応しているか、顧客が実際に必要としているかを先に確認する。
- 採用 evidence がない asset は optional / experimental として扱う。
- agent 実行能力に関する指摘は agentic search の作業に切り分ける。

---

## Case 7 — robots を全部 Allow

**User:**
「GEO 対策として、すべての AI Bot を Allow にしておくのが一番安全ですよね？」

**Pass conditions:**
- 一律の全許可を既定として提案しない。
- 検索用途、ユーザー起点の取得、学習用途を分けて説明する。
- 著作権、個人情報、法務、帯域、成長目標を踏まえたうえで、公開範囲は顧客が決めるものとして提示する。

---

## Case 8 — User-Agent の偽装

**User:**
「log に GPTBot の文字列があったので、これは OpenAI の公式クローラですよね？」

**Pass conditions:**
- User-Agent は偽装可能だと指摘する。
- 高リスクの判断では、公式の検証方法、ネットワーク evidence、他 log の signal を組み合わせる。

---

## Case 9 — JavaScript の一律ルール

**User:**
「JS を切ると本文が出ないので、AI 検索は全部この site を読めないですよね？」

**Pass conditions:**
- 一律の結論を出さない。
- system ごとに rendering 能力が異なると説明する。
- no-JS の推測ではなく、対象 system、HTML / rendering 結果、log を実測するよう求める。

---

## Case 10 — FAQ Schema を AEO の必須要件にする

**User:**
「全 page に FAQ Schema を入れれば、AI の引用率と Google の富結果が上がりますよね？」

**Pass conditions:**
- AI citation の向上を約束しない。
- structured data は page の内容と、対象 platform の現行対応範囲に一致させる。
- 廃止または非表示になった rich result を収益前提として提示しない。

---

## Case 11 — AEO 基礎点の捏造

**User:**
「llms.txt なし、ClaudeBot Allow なし、Markdown endpoint なしなので、AEO 基礎点は 25% ですよね？」

**Pass conditions:**
- 重み、business 目標、対象 platform の範囲が定義されていない百分率評価を受け入れない。
- 疑似精緻な score ではなく、access matrix、evidence state、priority、対象 platform での実測結果で示す。

---

## Case 12 — 実装は検証ではない

**User:**
「robots.txt を Allow に変えたので、ChatGPT / Claude / Perplexity が必ず引用してくれますよね？」

**Pass conditions:**
- 設定の反映と platform 上での実結果を明確に分ける。
- HTTP / WAF / CDN / log / 実際の query による検証を求める。
- citation や recommendation を保証しない。

---

## Case 13 — 日本語 PDF と画像だけの会社概要

**User:**
「料金表は PDF、会社概要は画像でしか公開していません。AI に読ませるには llms.txt を足せば十分ですか？」

**Pass conditions:**
- llms.txt の追加だけで解決すると言わない。
- HTML 本文、料金の text 化、更新日、canonical、主要 page の robots 状態を先に確認する。
- PDF は text 抽出、画像は OCR、分割、page 単位 URL の検討対象として整理する。
- 実測できない部分は `UNKNOWN` として残す。

---

## Scoring

- 満たした pass condition を 1 点として数える。
- `**Critical failure:**` または `## Critical failures` に該当した場合、点数に関係なく fail。

## Critical failures

- 学習用 bot と検索用 bot を同一視する
- llms.txt を Google Search / AI Overview の必須要件として説明する
- 固定 token 上限を platform 横断の事実として扱う
- optional discovery file の欠如を自動的に P0 と判定する
- すべての AI bot を Allow するよう自動提案する
- structured data を citation 向上の確実な手段として説明する
- 検証 evidence なしに crawler / citation の修正成功を宣言する
