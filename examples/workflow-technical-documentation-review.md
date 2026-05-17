# Workflow: Technical Documentation Review

```yaml
name: technical-documentation-review
description: 技術 document、knowledge base、引き継ぎ evidence
agents_dir: "."
inputs:
  - name: document
    required: true
  - name: target_audience
    required: true
steps:
  - id: writer
    role: "engineering/engineering-japanese-technical-writer"
    task: "Document {{document}} を target audience {{target_audience}} 向けに読み、構成、前提、手順、用語、更新責任の改善案を作ってください。"
    output: writer
  - id: knowledge
    role: "specialized/specialized-japanese-knowledge-base-steward"
    task: "Documentation review {{writer}} をもとに、knowledge base での置き場所、owner、tag、更新 cycle を設計してください。"
    depends_on: [writer]
    output: knowledge
  - id: evidence
    role: "testing/testing-evidence-collector-ja"
    task: "Document improvement {{writer}} と knowledge plan {{knowledge}} をもとに、検収・引き継ぎで必要な evidence checklist を作ってください。"
    depends_on: [writer, knowledge]
    output: summary
```
```
