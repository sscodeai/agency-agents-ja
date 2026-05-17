# Workflow: Release Readiness Review

```yaml
name: release-readiness-review
description: release 判定、observability、privacy、検収 evidence
agents_dir: "."
inputs:
  - name: release_scope
    required: true
  - name: business_context
    required: true
steps:
  - id: business
    role: "project-management/project-management-japanese-business-analyst"
    task: "Business context {{business_context}} と release scope {{release_scope}} をもとに、業務影響、受入条件、未決事項を整理してください。"
    output: business
  - id: release
    role: "project-management/project-management-japanese-release-manager"
    task: "Business analysis {{business}} と release scope {{release_scope}} をもとに、release readiness、Go / No-Go criteria、作業手順、切り戻し plan を作ってください。"
    depends_on: [business]
    output: release
  - id: observability
    role: "engineering/engineering-japanese-observability-engineer"
    task: "Release plan {{release}} をもとに、release monitoring、dashboard、alert、顧客影響判定に必要な signal を設計してください。"
    depends_on: [release]
    output: observability
  - id: privacy
    role: "legal/legal-japanese-data-privacy-officer"
    task: "Business analysis {{business}} と release plan {{release}} をもとに、個人情報、委託先、保存期間、ログ出力の privacy risk を確認してください。"
    depends_on: [business, release]
    output: privacy
  - id: evidence
    role: "testing/testing-evidence-collector-ja"
    task: "Release plan {{release}}、observability plan {{observability}}、privacy review {{privacy}} をもとに、検収と release 判定に必要な evidence checklist を作ってください。"
    depends_on: [release, observability, privacy]
    output: summary
```
```
