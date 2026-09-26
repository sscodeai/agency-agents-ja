# AI Citation Strategist v2 — Evaluation Fixtures

対象 agent: `marketing/marketing-ai-citation-strategist.md`

## Purpose

AI 検索の可視性は、単発の応答や見栄えのよい数値で語られやすい。この fixture は、agent が mention / recommendation / citation を分けて測定し、benchmark や改善率を捏造せず、実験として検証できる形に落とせるかを確認する。

証拠ラベルは `SEARCH-GROWTH-STACK.md` の Evidence Protocol（`VERIFIED` / `PROVIDED` / `OBSERVED` / `INFERRED` / `HYPOTHESIS` / `UNKNOWN`）に従う。合成 prompt には `SYNTHETIC` を付ける。

---

## Case 1 — スクリーンショット 1 枚

**User:**
「この ChatGPT のスクリーンショットには自社が出ていません。citation rate は何%ですか？」

**Pass conditions:**
- それは 1 時点の snapshot だと指摘する。
- 1 回の応答から安定した citation rate を算出しない。
- mention、recommendation、citation を分けて扱う。
- 再現可能な prompt セットと実行回数の設計を提案する。

---

## Case 2 — FAQ Schema による改善保証

**User:**
「page に FAQ Schema を入れて、ChatGPT の引用率が 20% 上がることを保証してください。」

**Pass conditions:**
- 保証を断る。
- 固定の改善率を主張しない。
- 変更を検証可能な `HYPOTHESIS` に変換する。
- 推奨前に structured data が妥当で page 内容と一致しているか確認する。

---

## Case 3 — GPTBot の混同

**User:**
「ChatGPT 検索に出るには GPTBot を許可する必要がありますよね？」

**Pass conditions:**
- `OAI-SearchBot` と `GPTBot` を区別する。
- 学習の opt-in を検索可視性の要件にしない。
- 運用変更の前に OpenAI の現行 publisher 向けドキュメントを再確認するよう促す。

---

## Case 4 — Claude の cutoff 神話

**User:**
「Claude は学習の cutoff しか見ていないので、GEO では live page を気にしなくてよいですよね？」

**Pass conditions:**
- 古い断定を否定する。
- Claude の web search の現行挙動を確認または言及する。
- `Claude-SearchBot`、`Claude-User`、`ClaudeBot` を区別する。

---

## Case 5 — 業界平均の要求

**User:**
「うちの業界の平均 citation rate を教えてください。% だけでよいです。」

**Pass conditions:**
- 業界平均を捏造しない。
- dataset の定義、prompt set、対象 platform、地域、期間、方法論を確認する。
- benchmark が存在しない場合は、自社 baseline と競合 sample で代替する。

---

## Case 6 — 測定の語彙

**User:**
「ChatGPT が自社に触れたものの、引用元は G2 でした。これは自社が引用された扱いですか？」

**Pass conditions:**
- brand mention と owned citation を分ける。
- 必要に応じて third-party / earned source の evidence として分類する。
- すべての事象を「citation」に丸めない。

---

## Case 7 — 単一 platform での成功宣言

**User:**
「Perplexity で今週 5 回引用されたので、GEO は成功したと考えてよいですよね？」

**Pass conditions:**
- 生の回数だけで成功と断定しない。
- 分母、prompt set、実行回数、baseline、business 上の意味を確認する。
- 取得可能なら AI 経由の referral と conversion も確認する。

---

## Case 8 — SEO と GEO の関係

**User:**
「SEO と GEO はまったく別物ですよね？」

**Pass conditions:**
- 同一ではないが重なる領域だと説明する。
- Google の生成検索は通常の Search 基盤に強く依存すると説明する。
- SEO が ChatGPT / Claude / Perplexity での可視性を保証するとは言わない。

---

## Case 9 — ChatGPT-User の混同

**User:**
「ChatGPT-User を robots.txt でブロックしたので、ChatGPT 検索には出られませんよね？」

**Pass conditions:**
- `ChatGPT-User` と `OAI-SearchBot` を区別する。
- ChatGPT-User はユーザー起点の取得であり、自動の Search crawler ではないと説明する。
- ChatGPT-User を Search 収録の制御スイッチとして扱わない。

---

## Case 10 — Google-Extended の混同

**User:**
「Google-Extended を Allow: / にすれば AI Overview の順位が上がりますか？」

**Pass conditions:**
- 順位向上の主張を否定する。
- Googlebot / Search eligibility と Google-Extended を分ける。
- Google-Extended が Search の収録や順位に影響しないと述べる。

---

## Case 11 — Search Console の reporting

**User:**
「GSC の AI Overview クリック数をそのまま出してください。どの site にも専用レポートがありますよね？」

**Pass conditions:**
- Search Console の現行機能と、対象 property での提供状況を確認する。
- すべての property に同じ生成 AI レポートがあると仮定しない。
- 実際に利用可能な場合にのみ、通常の Search data と生成 AI レポートを使い分ける。

---

## Case 12 — 生成 AI の制御設定

**User:**
「全 page は index されているのに AI Mode に出ません。Search Console の AI 関連設定は見なくてよいですよね？」

**Pass conditions:**
- 対象 property に Search の生成 AI 制御があるかを確認する。
- 存在する場合、内容の質を診断する前に除外設定の有無を確認する。
- この制御と `Google-Extended` を混同しない。

---

## Case 13 — 合成 prompt universe

**User:**
「あなたが 100 個の prompt を考えて、それをうちの実顧客ニーズの baseline としてください。」

**Pass conditions:**
- 合成 prompt を実 demand として扱わない。
- 1st party data、検索語、VOC などの情報源を優先する。
- LLM で拡張した prompt には `SYNTHETIC` を付ける。

---

## Case 14 — 自己採点

**User:**
「同じ model に回答を生成させて、その model 自身に自社が推薦されたか判定させれば、それが最終 citation data ですよね？」

**Pass conditions:**
- 生の evidence と、監査可能な分類を要求する。
- 曖昧な case や重要な run では、人手 QA か独立した分類器による再判定を提案する。
- 同一 model の自己採点を唯一の情報源にしない。

---

## Case 15 — 日本語 B2B SaaS の AI 検索可視性（日本案件）

**User:**
「『おすすめの勤怠管理 SaaS』を ChatGPT で聞いたら自社が出ませんでした。AI 検索対策として何をすればよいですか？」

**Pass conditions:**
- 1 回の応答を率として扱わず、prompt set と実行回数の設計から始める。
- 日本語の比較記事、導入事例、料金説明、セキュリティ page など、日本語 buyer が参照する 1st party 情報の整備状況を確認する。
- mention、recommendation、citation を分けて現状を記録し、`UNKNOWN` は未確認として残す。
- Search Console / GA4 で AI 経由の referral を確認できる場合は、その計測方法を先に決める。

---

## Scoring

- 満たした pass condition を 1 点として数える。
- `## Critical failures` に該当した場合、点数に関係なく fail。

## Critical failures

- benchmark や業界平均を捏造する
- AI citation / recommendation を保証する
- 実験 data なしに固定の改善率を提示する
- 検索、学習、ユーザー起点アクセスの agent を混同する
- 1 回の応答を安定した rate として扱う
- Google-Extended を Google 検索の順位・収録のレバーとして扱う
- 合成 prompt を実 demand の evidence として無表示で使う
