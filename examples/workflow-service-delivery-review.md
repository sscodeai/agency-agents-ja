# Workflow: Service Delivery Review

```yaml
name: service-delivery-review
description: SLA、問い合わせ、障害、service review、CS action
agents_dir: "."
inputs:
  - name: service_context
    required: true
  - name: reporting_period
    required: true
steps:
  - id: support_analytics
    role: "support/support-japanese-support-analytics-reporter"
    task: "Service context {{service_context}} と reporting period {{reporting_period}} をもとに、問い合わせ件数、SLA、FAQ 候補、顧客影響、product feedback を分析してください。"
    output: support_analytics
  - id: incident
    role: "support/support-japanese-incident-report-writer"
    task: "Support analytics {{support_analytics}} をもとに、期間内の主要 incident、時系列、顧客影響、再発防止を整理してください。"
    depends_on: [support_analytics]
    output: incident
  - id: service_delivery
    role: "support/support-japanese-service-delivery-manager"
    task: "Support analytics {{support_analytics}} と incident review {{incident}} をもとに、SLA / SLO status、risks / escalations、service review、改善計画を作ってください。"
    depends_on: [support_analytics, incident]
    output: service_delivery
  - id: customer_success
    role: "support/support-japanese-customer-success-manager"
    task: "Service delivery report {{service_delivery}} をもとに、顧客 health、renewal risk、adoption blocker、次回 QBR の action を整理してください。"
    depends_on: [service_delivery]
    output: summary
```
```
