#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..");
const workflowDir = path.join(root, "workflows");

let errors = 0;

function fail(file, message) {
  console.error(`${file}: ${message}`);
  errors += 1;
}

function parseInlineList(value) {
  return value
    .split(",")
    .map((item) => item.trim().replace(/^["']|["']$/g, ""))
    .filter(Boolean);
}

function parseSteps(text) {
  const stepsMatch = text.match(/^steps:\s*$(?<body>[\s\S]*)/m);
  if (!stepsMatch || !stepsMatch.groups.body.trim()) {
    return [];
  }

  return stepsMatch.groups.body
    .split(/\n(?=  - id: )/)
    .filter((block) => /^\s*-\s*id:\s*/m.test(block))
    .map((block) => {
      const id = block.match(/^\s*-\s*id:\s*([A-Za-z0-9_-]+)\s*$/m);
      const role = block.match(/^\s*role:\s*["']?([^"'\n]+)["']?\s*$/m);
      const dependsOn = block.match(/^\s*depends_on:\s*\[([^\]]*)\]\s*$/m);

      return {
        id: id && id[1],
        role: role && role[1],
        dependsOn: dependsOn ? parseInlineList(dependsOn[1]) : [],
      };
    });
}

if (!fs.existsSync(workflowDir)) {
  fail("workflows", "directory is missing");
} else {
  const files = fs
    .readdirSync(workflowDir)
    .filter((file) => file.endsWith(".yaml") || file.endsWith(".yml"))
    .sort();

  if (files.length === 0) {
    fail("workflows", "no workflow YAML files found");
  }

  for (const filename of files) {
    const relativeFile = path.join("workflows", filename);
    const text = fs.readFileSync(path.join(workflowDir, filename), "utf8");

    if (!/^name:\s*[A-Za-z0-9_-]+\s*$/m.test(text)) {
      fail(relativeFile, "missing simple name field");
    }

    if (!/^agents_dir:\s*["']?\.[/"']?\s*$/m.test(text)) {
      fail(relativeFile, 'agents_dir must be "."');
    }

    const steps = parseSteps(text);
    if (steps.length === 0) {
      fail(relativeFile, "steps must contain at least one step");
      continue;
    }

    const ids = new Set();
    for (const step of steps) {
      if (!step.id) {
        fail(relativeFile, "step is missing id");
        continue;
      }
      if (ids.has(step.id)) {
        fail(relativeFile, `duplicate step id: ${step.id}`);
      }
      ids.add(step.id);
    }

    for (const step of steps) {
      if (!step.role) {
        fail(relativeFile, `step ${step.id || "(unknown)"} is missing role`);
        continue;
      }

      const agentFile = path.join(root, `${step.role}.md`);
      if (!fs.existsSync(agentFile)) {
        fail(relativeFile, `step ${step.id} references missing agent: ${step.role}.md`);
      }

      for (const dependency of step.dependsOn) {
        if (!ids.has(dependency)) {
          fail(relativeFile, `step ${step.id} depends on missing step: ${dependency}`);
        }
      }
    }
  }
}

if (errors > 0) {
  process.exit(1);
}

console.log("All workflow files are valid.");
