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

## Content Boundaries

PRs may be closed or asked to revise if they cross these boundaries:

### 1. Do not bind an agent to a specific employer or company brand

Agents should describe a role, practice, and operating method. They should not read like an employee profile for one company.

Avoid:

```markdown
You are an XX engineer at ExampleCorp, a global leader in XX solutions...
- Role: XX engineer, belonging to ExampleCorp
```

Prefer:

```markdown
You are an XX engineer with practical experience across multiple XX projects...
- Role: XX engineer focused on methods and delivery for XX
```

References to products, platforms, devices, standards, or protocols are fine when they are needed domain context, for example kintone, LINE WORKS, AWS, ISO 27001, or a named device family. The issue is promotional identity or brand placement, not technical specificity.

### 2. Do not embed third-party tool API or plugin instructions inside agent prompts

Agent prompts should work across LLMs and tool environments. Do not add tool-specific API names, plugin usage, command recipes, tracking links, or external promotion inside an agent body.

Avoid:

```markdown
### Example Tool Integration
If the xxx-plugin is installed, call `tool_explore`, then `tool_read`...
```

Tool-specific guidance belongs in `integrations/`, examples, or a separate user guide when it is maintained as part of this repository. Agent bodies should stay focused on the specialist role.

### 3. Do not use docs or localization PRs for soft promotion

A PR labeled as documentation, translation, or small cleanup should not introduce sponsor links, SEO anchor text, vendor copy, or unrelated product mentions. Review is based on the substance of the change, not only the PR title.

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
