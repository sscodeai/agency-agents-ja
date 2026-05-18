#!/usr/bin/env node
const { existsSync, readdirSync, readFileSync, writeFileSync } = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const readmePath = path.join(root, "README.md");
const superpowersIntegrationPath = path.join(root, "docs", "superpowers-ja-integration.md");
const workflowDir = path.join(root, "workflows");
const examplesDir = path.join(root, "examples");

const ORDER = [
  "japanese-sier-requirements-review",
  "acceptance-readiness-review",
  "ai-governance-rollout",
  "api-integration-delivery",
  "b2b-saas-release",
  "b2b-lead-generation",
  "business-ui-readiness-review",
  "change-management-review",
  "csv-data-migration-readiness",
  "customer-health-review",
  "enterprise-architecture-roadmap",
  "incident-report",
  "it-onboarding-offboarding",
  "japan-go-to-market-campaign",
  "kintone-business-app",
  "manufacturing-dx-assessment",
  "quality-governance-review",
  "rfp-response",
  "release-readiness-review",
  "revenue-governance-review",
  "service-delivery-review",
  "technical-documentation-review",
  "vendor-cost-review",
];

function parseWorkflowMeta(file) {
  const text = readFileSync(file, "utf8");
  const name = text.match(/^name:\s*([A-Za-z0-9_-]+)\s*$/m);
  const description = text.match(/^description:\s*(.+?)\s*$/m);
  return {
    name: name && name[1],
    description: description && description[1].replace(/^["']|["']$/g, ""),
  };
}

function examplePathFor(name) {
  const exact = path.join(examplesDir, `workflow-${name}.md`);
  if (existsSync(exact)) return `examples/workflow-${name}.md`;

  // Historical shorter example filename.
  if (name === "japanese-sier-requirements-review") {
    const legacy = path.join(examplesDir, "workflow-japanese-sier-requirements.md");
    if (existsSync(legacy)) return "examples/workflow-japanese-sier-requirements.md";
  }

  return "";
}

function listWorkflows() {
  if (!existsSync(workflowDir)) return [];

  const byName = new Map();
  for (const file of readdirSync(workflowDir)) {
    if (!file.endsWith(".yaml") && !file.endsWith(".yml")) continue;
    const { name, description } = parseWorkflowMeta(path.join(workflowDir, file));
    if (!name) continue;
    byName.set(name, { path: `workflows/${file}`, description });
  }

  const known = ORDER.filter((name) => byName.has(name));
  const unknown = [...byName.keys()]
    .filter((name) => !ORDER.includes(name))
    .sort();

  return [...known, ...unknown].map((name) => ({
    name,
    workflowPath: byName.get(name).path,
    description: byName.get(name).description || "",
    examplePath: examplePathFor(name),
  }));
}

function renderReadmeTable() {
  const lines = [
    "| Workflow | 用途 | Example |",
    "| --- | --- | --- |",
  ];

  for (const row of listWorkflows()) {
    const example = row.examplePath ? `\`${row.examplePath}\`` : "";
    lines.push(`| \`${row.workflowPath}\` | ${row.description} | ${example} |`);
  }

  return lines.join("\n");
}

function renderDocsTable() {
  const lines = [
    "| Workflow | 用途 |",
    "| --- | --- |",
  ];

  for (const row of listWorkflows()) {
    lines.push(`| \`${row.workflowPath}\` | ${row.description} |`);
  }

  return lines.join("\n");
}

function replaceTable(document, startMarker, tableHeader, endMarker, table) {
  const markerIndex = document.indexOf(startMarker);
  if (markerIndex === -1) {
    throw new Error(`Document is missing section: ${startMarker}`);
  }

  const beforeSection = document.slice(0, markerIndex);
  const sectionAndAfter = document.slice(markerIndex);
  const tableStart = sectionAndAfter.indexOf(tableHeader);
  if (tableStart === -1) {
    throw new Error(`Document is missing table: ${tableHeader}`);
  }

  const nextSection = sectionAndAfter.indexOf(endMarker, tableStart);
  if (nextSection === -1) {
    throw new Error(`Document is missing section after workflow table: ${endMarker.trim()}`);
  }

  return [
    beforeSection,
    sectionAndAfter.slice(0, tableStart),
    table,
    "\n",
    sectionAndAfter.slice(nextSection),
  ].join("");
}

const targets = [
  {
    path: readmePath,
    label: "README.md workflow table",
    table: renderReadmeTable(),
    startMarker: "### Workflow YAML",
    tableHeader: "| Workflow | 用途 | Example |",
    endMarker: "\n### Agent を探す",
  },
  {
    path: superpowersIntegrationPath,
    label: "docs/superpowers-ja-integration.md workflow table",
    table: renderDocsTable(),
    startMarker: "## Workflow",
    tableHeader: "| Workflow | 用途 |",
    endMarker: "\n## 使い方",
  },
];

const updates = targets.map((target) => {
  const current = existsSync(target.path) ? readFileSync(target.path, "utf8") : "";
  const next = replaceTable(
    current,
    target.startMarker,
    target.tableHeader,
    target.endMarker,
    target.table,
  );
  return { ...target, current, next };
});

if (process.argv.includes("--check")) {
  let ok = true;
  for (const update of updates) {
    if (update.current !== update.next) {
      console.error(`${update.label} is out of date. Run: node scripts/generate-workflow-table.js`);
      ok = false;
    } else {
      console.log(`${update.label} is up to date.`);
    }
  }
  if (!ok) process.exit(1);
} else {
  for (const update of updates) {
    writeFileSync(update.path, update.next, "utf8");
    console.log(`Updated ${update.label}.`);
  }
}
