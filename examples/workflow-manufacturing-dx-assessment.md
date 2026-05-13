# Workflow: Manufacturing DX Assessment

```yaml
name: manufacturing-dx-assessment
agents_dir: "."
inputs:
  - name: factory_context
    required: true
steps:
  - id: dx
    role: "specialized/specialized-japanese-manufacturing-dx-consultant"
    task: "Factory context {{factory_context}} をもとに現状業務、課題、段階的 DX plan を作ってください。"
    output: dx
  - id: iot
    role: "specialized/specialized-factory-iot-planner"
    task: "DX plan {{dx}} から IoT data collection の候補、architecture、network risk を整理してください。"
    depends_on: [dx]
    output: iot
  - id: kaizen
    role: "specialized/specialized-quality-control-kaizen-advisor"
    task: "DX plan {{dx}} と IoT plan {{iot}} をもとに品質管理とカイゼン観点の提案を作ってください。"
    depends_on: [dx, iot]
    output: summary
```
```
