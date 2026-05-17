# Workflow: Customer Health Review

```yaml
name: customer-health-review
description: 顧客 health、support analytics、account strategy、risk
agents_dir: "."
inputs:
  - name: account_notes
    required: true
  - name: support_data
    required: true
steps:
  - id: support_analytics
    role: "support/support-japanese-support-analytics-reporter"
    task: "Support data {{support_data}} をもとに問い合わせ傾向、SLA、顧客影響、改善 action を分析してください。"
    output: support_analytics
  - id: csm
    role: "support/support-japanese-customer-success-manager"
    task: "Account notes {{account_notes}} と support analytics {{support_analytics}} をもとに account health、adoption、renewal risk を整理してください。"
    depends_on: [support_analytics]
    output: csm
  - id: account_strategy
    role: "sales/sales-japanese-account-strategist"
    task: "Customer success summary {{csm}} をもとに stakeholder map、renewal / expansion strategy、30 / 60 / 90 day action を作ってください。"
    depends_on: [csm]
    output: account_strategy
  - id: risk
    role: "specialized/specialized-japanese-risk-assessor"
    task: "Support analytics {{support_analytics}}、customer success summary {{csm}}、account strategy {{account_strategy}} をもとに顧客維持と契約更新の risk register を作ってください。"
    depends_on: [support_analytics, csm, account_strategy]
    output: summary
```
```
