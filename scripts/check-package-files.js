#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
const divisions = JSON.parse(fs.readFileSync(path.join(root, 'divisions.json'), 'utf8')).divisions || {};

const requiredDirs = [
  'bin',
  'scripts',
  'integrations',
  'examples',
  'workflows',
  'docs',
  'strategy',
  ...Object.keys(divisions),
].sort();

const requiredFiles = [
  'divisions.json',
  'tools.json',
  'README.md',
  'AGENT-LIST.md',
  'TRANSLATION-PROGRESS.md',
  'UPSTREAM-COVERAGE.md',
  'CHANGELOG.md',
  'CONTRIBUTING.md',
  'ROADMAP.md',
  'LICENSE',
];

const files = Array.isArray(pkg.files) ? pkg.files : [];
let errors = 0;

function fail(message) {
  console.error(`ERROR ${message}`);
  errors += 1;
}

for (const dir of requiredDirs) {
  if (!files.includes(`${dir}/`)) {
    fail(`package.json files is missing "${dir}/"`);
  }
}

for (const file of requiredFiles) {
  if (!files.includes(file)) {
    fail(`package.json files is missing "${file}"`);
  }
}

if (errors > 0) {
  console.error(`FAILED: ${errors} package file allowlist error(s).`);
  process.exit(1);
}

console.log(`PASSED: package.json publishes ${requiredDirs.length} required directories and ${requiredFiles.length} required files.`);
