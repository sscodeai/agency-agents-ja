# Workflow: Enterprise Architecture Roadmap

```yaml
name: enterprise-architecture-roadmap
agents_dir: "."
inputs:
  - name: business_context
    required: true
  - name: system_landscape
    required: true
steps:
  - id: enterprise
    role: "engineering/engineering-japanese-enterprise-architect"
    task: "Business context {{business_context}} と system landscape {{system_landscape}} をもとに、current landscape、target architecture principles、capability / system map、migration roadmap を作ってください。"
    output: enterprise
  - id: data_governance
    role: "engineering/engineering-japanese-data-governance-steward"
    task: "Enterprise architecture brief {{enterprise}} をもとに、data owner、source of truth、quality rule、access rule、retention rule を整理してください。"
    depends_on: [enterprise]
    output: data_governance
  - id: security
    role: "engineering/engineering-japanese-security-engineer"
    task: "Enterprise architecture brief {{enterprise}} と data governance {{data_governance}} をもとに、identity、権限、監査ログ、個人情報、委託先 risk を確認してください。"
    depends_on: [enterprise, data_governance]
    output: security
  - id: modernization
    role: "engineering/engineering-japanese-legacy-modernization-engineer"
    task: "Enterprise architecture brief {{enterprise}} と security review {{security}} をもとに、legacy modernization の段階移行、並行稼働、rollback、保守期限対応を整理してください。"
    depends_on: [enterprise, security]
    output: summary
```
```
