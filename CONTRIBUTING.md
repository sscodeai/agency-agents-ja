# Contributing

Thanks for improving `agency-agents-ja`.

## Agent Types

Use `source: japan-original` for agents independently designed for Japanese IT delivery, SIer, SaaS, EC, manufacturing DX, public sector, compliance, or operations workflows.

Use `source: upstream` for agents that correspond to an upstream file in [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents). These agents must keep `upstream_path` and `translation_status`.

## Frontmatter

Every agent must include:

```yaml
---
name: 日本語名
description: 呼び出す場面、専門性、成果物
emoji: 🧩
color: blue
source: japan-original
---
```

Upstream-aligned agents must include:

```yaml
source: upstream
upstream_path: engineering/example-agent.md
upstream_name: Example Agent
translation_status: skeleton
```

`translation_status` values:

- `skeleton`: Japan-context wrapper exists, but the upstream prompt is not fully translated yet.
- `translated`: Upstream prompt has been fully translated while preserving the upstream intent.
- `adapted`: Upstream prompt was translated, then intentionally adapted for the Japanese market.

Do not put temporary status text such as `[upstream]` in `name`; use frontmatter instead.

## Agent Body

Prefer this structure:

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

Japan-original agents should be concrete enough to use in real delivery work. Include expected inputs, risks, evidence, decision criteria, and output format.

Upstream-aligned agents should preserve the upstream role concept while making Japanese terminology, workflows, compliance, approval, and operations assumptions explicit.

## Workflows

Workflow YAML files live in `workflows/`. Example files live in `examples/` and must contain a YAML block synchronized with the workflow file.

Run:

```bash
npm run generate
npm run validate
```

`npm run generate` updates:

- `AGENT-LIST.md`
- `TRANSLATION-PROGRESS.md`
- `UPSTREAM-COVERAGE.md`
- workflow tables in `README.md` and `docs/superpowers-ja-integration.md`

`npm run validate` checks frontmatter, generated files, workflow role references, example synchronization, and non-Japan localization drift.
