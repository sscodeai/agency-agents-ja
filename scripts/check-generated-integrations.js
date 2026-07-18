#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const agentDirs = [
  'academic',
  'design',
  'engineering',
  'finance',
  'game-development',
  'gis',
  'healthcare',
  'hr',
  'legal',
  'marketing',
  'paid-media',
  'product',
  'project-management',
  'sales',
  'security',
  'spatial-computing',
  'specialized',
  'support',
  'supply-chain',
  'testing',
];

let errors = 0;

function fail(message) {
  console.error(`ERROR ${message}`);
  errors += 1;
}

function exists(rel) {
  return fs.existsSync(path.join(root, rel));
}

function read(rel) {
  return fs.readFileSync(path.join(root, rel), 'utf8');
}

function listFiles(dir, predicate, out = []) {
  const fullDir = path.join(root, dir);
  if (!fs.existsSync(fullDir)) return out;
  for (const entry of fs.readdirSync(fullDir, { withFileTypes: true })) {
    const rel = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      listFiles(rel, predicate, out);
    } else if (entry.isFile() && predicate(rel)) {
      out.push(rel);
    }
  }
  return out;
}

function directEntries(dir, predicate) {
  const fullDir = path.join(root, dir);
  if (!fs.existsSync(fullDir)) return [];
  return fs.readdirSync(fullDir, { withFileTypes: true })
    .filter(predicate)
    .map((entry) => path.join(dir, entry.name))
    .sort();
}

function isAgentFile(rel) {
  if (!rel.endsWith('.md')) return false;
  const text = read(rel);
  return text.startsWith('---\n') && /^name:\s*.+$/m.test(text);
}

const sourceAgents = agentDirs.flatMap((dir) => listFiles(dir, isAgentFile)).sort();
const expected = sourceAgents.length;

function checkCount(label, actual, detail) {
  if (actual !== expected) {
    fail(`${label}: expected ${expected} generated agents, found ${actual}${detail ? ` (${detail})` : ''}`);
  }
}

function dirCount(dir, filter) {
  return directEntries(dir, filter).length;
}

checkCount(
  'antigravity',
  dirCount('integrations/antigravity', (entry) => entry.isDirectory() && entry.name.startsWith('agency-')),
  'integrations/antigravity/agency-*',
);
checkCount(
  'gemini-cli',
  dirCount('integrations/gemini-cli/skills', (entry) => entry.isDirectory()),
  'integrations/gemini-cli/skills/*',
);
if (!exists('integrations/gemini-cli/gemini-extension.json')) {
  fail('gemini-cli: missing integrations/gemini-cli/gemini-extension.json');
}
checkCount(
  'opencode',
  dirCount('integrations/opencode/agents', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  'integrations/opencode/agents/*.md',
);
checkCount(
  'cursor',
  dirCount('integrations/cursor/rules', (entry) => entry.isFile() && entry.name.endsWith('.mdc')),
  'integrations/cursor/rules/*.mdc',
);
checkCount(
  'openclaw',
  dirCount('integrations/openclaw', (entry) => entry.isDirectory()),
  'integrations/openclaw/*',
);
checkCount(
  'qwen',
  dirCount('integrations/qwen/agents', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  'integrations/qwen/agents/*.md',
);
checkCount(
  'zcode',
  dirCount('integrations/zcode/agents', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  'integrations/zcode/agents/*.md',
);
checkCount(
  'kimi',
  dirCount('integrations/kimi', (entry) => entry.isDirectory()),
  'integrations/kimi/*',
);
checkCount(
  'codex',
  dirCount('integrations/codex/agents', (entry) => entry.isFile() && entry.name.endsWith('.toml')),
  'integrations/codex/agents/*.toml',
);
checkCount(
  'osaurus',
  dirCount('integrations/osaurus', (entry) => entry.isDirectory() && entry.name.startsWith('agency-')),
  'integrations/osaurus/agency-*',
);
checkCount(
  'vibe agents',
  dirCount('integrations/vibe/agents', (entry) => entry.isFile() && entry.name.endsWith('.toml')),
  'integrations/vibe/agents/*.toml',
);
checkCount(
  'vibe prompts',
  dirCount('integrations/vibe/prompts', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  'integrations/vibe/prompts/*.md',
);

if (!exists('integrations/aider/CONVENTIONS.md')) {
  fail('aider: missing integrations/aider/CONVENTIONS.md');
}
if (!exists('integrations/windsurf/.windsurfrules')) {
  fail('windsurf: missing integrations/windsurf/.windsurfrules');
}

const hermesData = 'integrations/hermes/agency-agents-router/data/agents.json';
if (!exists(hermesData)) {
  fail(`hermes: missing ${hermesData}`);
} else {
  const agents = JSON.parse(read(hermesData));
  checkCount('hermes', Array.isArray(agents) ? agents.length : 0, hermesData);
}
for (const rel of [
  'integrations/hermes/agency-agents-router/plugin.yaml',
  'integrations/hermes/agency-agents-router/__init__.py',
]) {
  if (!exists(rel)) fail(`hermes: missing ${rel}`);
}

if (errors > 0) {
  console.error(`FAILED: ${errors} generated integration check(s). Run: ./scripts/convert.sh`);
  process.exit(1);
}

console.log(`PASSED: generated integrations are complete for ${expected} agents.`);
