# Workflow: Acceptance Readiness Review

```yaml
name: acceptance-readiness-review
description: 検収条件、QA 結果、証跡、未解決事項、顧客承認の受入 readiness
agents_dir: "."
inputs:
  - name: delivery_scope
    required: true
  - name: customer_acceptance_context
    required: true
steps:
  - id: business
    role: "project-management/project-management-japanese-business-analyst"
    task: "Delivery scope {{delivery_scope}} と customer acceptance context {{customer_acceptance_context}} をもとに、業務影響、stakeholder、検収で確認すべき業務観点、未決事項を整理してください。"
    output: business
  - id: acceptance
    role: "project-management/project-management-acceptance-criteria-writer"
    task: "Business analysis {{business}} をもとに、testable な受入条件、検収条件、対象外、顧客確認観点を作ってください。"
    depends_on: [business]
    output: acceptance
  - id: qa
    role: "testing/testing-japanese-quality-assurance-manager"
    task: "Acceptance criteria {{acceptance}} と delivery scope {{delivery_scope}} をもとに、QA gate、未解決 bug、known issue、条件付き承認の risk を評価してください。"
    depends_on: [acceptance]
    output: qa
  - id: evidence
    role: "testing/testing-evidence-collector-ja"
    task: "Acceptance criteria {{acceptance}} と QA review {{qa}} をもとに、顧客検収に必要な evidence checklist、提出物、未確認項目を整理してください。"
    depends_on: [acceptance, qa]
    output: evidence
  - id: pm
    role: "project-management/project-management-japanese-pm"
    task: "Business analysis {{business}}、acceptance criteria {{acceptance}}、QA review {{qa}}、evidence checklist {{evidence}} をもとに、検収判定会の agenda、承認者、残課題、次 action をまとめてください。"
    depends_on: [business, acceptance, qa, evidence]
    output: summary
```
```
