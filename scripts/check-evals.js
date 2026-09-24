#!/usr/bin/env node
//
// Validates the evaluation fixtures under evals/:
//   1. A fixture is not an agent: it must not start with YAML frontmatter, so
//      the division checks never mistake evals/ for a source agent category.
//   2. Every fixture must point at the agent it evaluates, and that path must
//      exist in the repository.
//   3. Every fixture must document Purpose, at least MIN_CASES cases with pass
//      conditions, and a Scoring section, so a fixture cannot rot into prose.
//
// Usage: node scripts/check-evals.js

const { existsSync, readdirSync, readFileSync } = require('fs');
const { join, relative, resolve } = require('path');

const root = resolve(__dirname, '..');
const evalsRoot = join(root, 'evals');
const MIN_CASES = 3;
const AGENT_PATH_RE = /`([a-z0-9-]+\/[a-z0-9-]+\.md)`/g;

const errors = [];

function fail(message) {
  errors.push(message);
}

function listMarkdownFiles(dir) {
  const files = [];
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...listMarkdownFiles(path));
    } else if (entry.isFile() && entry.name.endsWith('.md')) {
      files.push(path);
    }
  }
  return files.sort();
}

function referencedAgentPaths(text) {
  const paths = new Set();
  for (const match of text.matchAll(AGENT_PATH_RE)) {
    paths.add(match[1]);
  }
  return [...paths];
}

function caseSections(text) {
  return text.split(/\n(?=## Case\b)/).slice(1);
}

function checkFixture(file) {
  const rel = relative(root, file);
  const text = readFileSync(file, 'utf8');
  const lines = text.split('\n');

  if (lines[0].trim() === '---') {
    fail(`${rel}: evaluation fixtures must not start with YAML frontmatter`);
  }
  if (!/^# \S/m.test(text)) {
    fail(`${rel}: missing a '# ' title line`);
  }
  if (!/^## Purpose$/m.test(text)) {
    fail(`${rel}: missing '## Purpose'`);
  }

  const cases = caseSections(text);
  if (cases.length < MIN_CASES) {
    fail(`${rel}: expected at least ${MIN_CASES} '## Case' sections, found ${cases.length}`);
  }
  for (const [index, section] of cases.entries()) {
    const heading = (section.split('\n')[0] || '').trim();
    if (!/\*\*Pass conditions:\*\*/.test(section)) {
      fail(`${rel}: ${heading || `case ${index + 1}`} is missing '**Pass conditions:**'`);
    }
    if (!/\*\*User:\*\*/.test(section)) {
      fail(`${rel}: ${heading || `case ${index + 1}`} is missing '**User:**'`);
    }
  }

  if (!/^## Scoring$/m.test(text)) {
    fail(`${rel}: missing '## Scoring'`);
  }

  const agentPaths = referencedAgentPaths(text);
  if (agentPaths.length === 0) {
    fail(`${rel}: no target agent path found (write it as \`division/agent-file.md\`)`);
  }
  for (const agentPath of agentPaths) {
    if (!existsSync(join(root, agentPath))) {
      fail(`${rel}: referenced agent path does not exist: ${agentPath}`);
    }
  }
}

if (!existsSync(evalsRoot)) {
  console.log('No evals/ directory, nothing to check.');
  process.exit(0);
}

const fixtures = listMarkdownFiles(evalsRoot).filter(file => file !== join(evalsRoot, 'README.md'));

if (fixtures.length === 0) {
  fail('evals/: no fixture files found');
}

for (const fixture of fixtures) {
  checkFixture(fixture);
}

if (errors.length > 0) {
  console.error('Evaluation fixture check failed:');
  for (const error of errors) {
    console.error(`- ${error}`);
  }
  process.exit(1);
}

console.log(`Evaluation fixture check passed: ${fixtures.length} fixture(s).`);
