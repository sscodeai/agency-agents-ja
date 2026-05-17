# Workflow: Quality Governance Review

```yaml
name: quality-governance-review
description: 品質方針、QA gate、不具合傾向、検収 readiness
agents_dir: "."
inputs:
  - name: quality_context
    required: true
  - name: release_scope
    required: true
steps:
  - id: qa_plan
    role: "testing/testing-japanese-qa-planner"
    task: "Quality context {{quality_context}} と release scope {{release_scope}} をもとに、test level、test matrix、entry / exit criteria、regression scope を整理してください。"
    output: qa_plan
  - id: qa_management
    role: "testing/testing-japanese-quality-assurance-manager"
    task: "QA plan {{qa_plan}} をもとに、品質目標、QA gate、不具合傾向、release / 検収 risk、Go / No-Go recommendation を作ってください。"
    depends_on: [qa_plan]
    output: qa_management
  - id: release
    role: "project-management/project-management-japanese-release-manager"
    task: "QA management review {{qa_management}} と release scope {{release_scope}} をもとに、release readiness、known issue、承認条件、切り戻し plan を整理してください。"
    depends_on: [qa_management]
    output: release
  - id: evidence
    role: "testing/testing-evidence-collector-ja"
    task: "QA plan {{qa_plan}}、QA management review {{qa_management}}、release plan {{release}} をもとに、検収と品質判定に必要な evidence checklist を作ってください。"
    depends_on: [qa_plan, qa_management, release]
    output: summary
```
```
