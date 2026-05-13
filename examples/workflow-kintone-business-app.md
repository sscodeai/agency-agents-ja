# Workflow: kintone Business App

```yaml
name: kintone-business-app
agents_dir: "."
inputs:
  - name: business_request
    required: true
steps:
  - id: requirements
    role: "engineering/engineering-japanese-requirements-engineer"
    task: "Business request {{business_request}} を要件、受入条件、未決事項へ整理してください。"
    output: requirements
  - id: app_design
    role: "engineering/engineering-kintone-developer"
    task: "Requirements {{requirements}} をもとに kintone app design、field、process management、権限を設計してください。"
    depends_on: [requirements]
    output: app_design
  - id: evidence
    role: "testing/testing-evidence-collector-ja"
    task: "kintone app design {{app_design}} の検収 evidence plan を作ってください。"
    depends_on: [app_design]
    output: summary
```
```
