#!/usr/bin/env node
//
// Validates the GitHub Actions workflows under .github/workflows/.
//
// scripts/validate-workflows.js only covers the agent workflow YAMLs in
// workflows/. Nothing parsed .github/workflows/, so release.yml shipped with a
// Markdown-style ">" block: YAML reads that as a folded scalar header, the file
// never parsed, GitHub marked the workflow invalid, and every push produced a
// failed run with no logs to inspect.
//
// Checks, per file:
//   1. The file parses as YAML.
//   2. The root is a mapping with name, on and jobs.
//   3. Every job declares runs-on and a non-empty steps list (unless it calls a
//      reusable workflow with uses).
//   4. Every step has exactly one of uses or run.

const { existsSync, readdirSync, readFileSync } = require('fs');
const { join } = require('path');
const YAML = require('yaml');

const root = process.cwd();
const workflowDir = join(root, '.github', 'workflows');

let errors = 0;

function fail(file, message) {
  console.error(`${file}: ${message}`);
  errors += 1;
}

function isMapping(value) {
  return value !== null && typeof value === 'object' && !Array.isArray(value);
}

if (!existsSync(workflowDir)) {
  console.log('No .github/workflows directory, nothing to check.');
  process.exit(0);
}

const files = readdirSync(workflowDir)
  .filter((name) => name.endsWith('.yml') || name.endsWith('.yaml'))
  .sort();

if (files.length === 0) {
  fail('.github/workflows', 'no workflow files found');
}

for (const name of files) {
  const rel = `.github/workflows/${name}`;
  let doc;

  try {
    doc = YAML.parse(readFileSync(join(workflowDir, name), 'utf8'));
  } catch (error) {
    fail(rel, `invalid YAML: ${String(error.message).split('\n')[0]}`);
    continue;
  }

  if (!isMapping(doc)) {
    fail(rel, 'expected a mapping at the document root');
    continue;
  }

  for (const key of ['name', 'on', 'jobs']) {
    if (doc[key] === undefined || doc[key] === null) {
      fail(rel, `missing required key '${key}'`);
    }
  }

  if (!isMapping(doc.jobs)) {
    fail(rel, "'jobs' must be a mapping");
    continue;
  }

  const jobIds = Object.keys(doc.jobs);
  if (jobIds.length === 0) {
    fail(rel, "'jobs' has no entries");
  }

  for (const jobId of jobIds) {
    const job = doc.jobs[jobId];
    const where = `jobs.${jobId}`;

    if (!isMapping(job)) {
      fail(rel, `${where} must be a mapping`);
      continue;
    }

    // A job that calls a reusable workflow has no runner or steps of its own.
    if (job.uses !== undefined) {
      continue;
    }

    if (job['runs-on'] === undefined) {
      fail(rel, `${where} is missing 'runs-on'`);
    }

    if (!Array.isArray(job.steps) || job.steps.length === 0) {
      fail(rel, `${where} must declare a non-empty 'steps' list`);
      continue;
    }

    for (const [index, step] of job.steps.entries()) {
      const stepWhere = `${where}.steps[${index}]`;

      if (!isMapping(step)) {
        fail(rel, `${stepWhere} must be a mapping`);
        continue;
      }

      const hasUses = typeof step.uses === 'string';
      const hasRun = typeof step.run === 'string';
      if (hasUses === hasRun) {
        fail(rel, `${stepWhere} must have exactly one of 'uses' or 'run'`);
      }
    }
  }
}

if (errors > 0) {
  console.error(`FAILED: ${errors} GitHub Actions workflow error(s).`);
  process.exit(1);
}

console.log(`PASSED: ${files.length} GitHub Actions workflow file(s) parse and declare name, on, and jobs.`);
