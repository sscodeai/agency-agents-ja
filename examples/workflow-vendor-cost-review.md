# Workflow: Vendor Cost Review

```yaml
name: vendor-cost-review
description: vendor 調達、risk、FinOps、pricing、契約単位
agents_dir: "."
inputs:
  - name: purchase_context
    required: true
  - name: vendor_options
    required: true
steps:
  - id: market
    role: "marketing/marketing-japanese-market-researcher"
    task: "Purchase context {{purchase_context}} と vendor options {{vendor_options}} をもとに、日本市場での代替手段、競合、購買 process、調達上の論点を整理してください。"
    output: market
  - id: procurement
    role: "supply-chain/supply-chain-japanese-procurement-manager"
    task: "Market research {{market}} と vendor options {{vendor_options}} をもとに、評価基準、見積比較、稟議、発注、検収 flow を作ってください。"
    depends_on: [market]
    output: procurement
  - id: vendor_risk
    role: "supply-chain/supply-chain-japanese-vendor-risk-manager"
    task: "Procurement plan {{procurement}} をもとに、vendor security、privacy、BCP、contract、exit risk を評価してください。"
    depends_on: [procurement]
    output: vendor_risk
  - id: finops
    role: "finance/finance-japanese-finops-analyst"
    task: "Procurement plan {{procurement}} と vendor risk {{vendor_risk}} をもとに、cloud / SaaS / license cost、予算 impact、cost optimization action を整理してください。"
    depends_on: [procurement, vendor_risk]
    output: finops
  - id: pricing
    role: "specialized/specialized-japanese-pricing-strategist"
    task: "Market research {{market}}、procurement plan {{procurement}}、FinOps report {{finops}} をもとに、価格交渉、契約単位、discount / approval rule の提案を作ってください。"
    depends_on: [market, procurement, finops]
    output: summary
```
```
