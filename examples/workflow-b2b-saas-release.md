# Workflow: B2B SaaS Release

```yaml
name: b2b-saas-release
description: B2B SaaS release、QA、release note、CS
agents_dir: "."
inputs:
  - name: release_scope
    required: true
  - name: target_date
    required: true
steps:
  - id: product
    role: "product/product-japanese-b2b-saas-planner"
    task: "{{release_scope}} の release scope、顧客影響、success metrics を整理してください。"
    output: product
  - id: qa
    role: "testing/testing-japanese-qa-planner"
    task: "Release scope {{product}} をもとに QA plan と exit criteria を作ってください。"
    depends_on: [product]
    output: qa
  - id: release_note
    role: "support/support-release-note-writer-ja"
    task: "Release scope {{product}} と QA plan {{qa}} をもとに、{{target_date}} 向けの release note を作ってください。"
    depends_on: [product, qa]
    output: release_note
  - id: cs
    role: "support/support-japanese-customer-success-manager"
    task: "Release note {{release_note}} をもとに customer success の案内と high-touch 顧客向け follow-up を作ってください。"
    depends_on: [release_note]
    output: summary
```
```
