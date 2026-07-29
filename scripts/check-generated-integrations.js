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
const sourceSlugs = sourceAgents.map((rel) => path.basename(rel, '.md')).sort();
const agencySlugs = sourceSlugs.map((slug) => `agency-${slug}`).sort();

function checkCount(label, actual, detail) {
  if (actual !== expected) {
    fail(`${label}: expected ${expected} generated agents, found ${actual}${detail ? ` (${detail})` : ''}`);
  }
}

function checkUnique(label, values) {
  const seen = new Set();
  for (const value of values) {
    if (seen.has(value)) {
      fail(`${label}: duplicate ${value}`);
    }
    seen.add(value);
  }
}

function checkExactSet(label, actual, expectedItems, detail) {
  checkCount(label, actual.length, detail);

  const actualSet = new Set(actual);
  const expectedSet = new Set(expectedItems);

  for (const expectedItem of expectedItems) {
    if (!actualSet.has(expectedItem)) {
      fail(`${label}: missing ${expectedItem}`);
    }
  }

  for (const actualItem of actual) {
    if (!expectedSet.has(actualItem)) {
      fail(`${label}: unexpected ${actualItem}`);
    }
  }
}

function checkRequiredFiles(label, dirs, filenames) {
  for (const dir of dirs) {
    for (const filename of filenames) {
      const rel = path.join(dir, filename);
      if (!exists(rel)) {
        fail(`${label}: missing ${rel}`);
      }
    }
  }
}

function expectedFiles(dir, ext) {
  return sourceSlugs.map((slug) => path.join(dir, `${slug}${ext}`)).sort();
}

function expectedDirs(dir, slugs = sourceSlugs) {
  return slugs.map((slug) => path.join(dir, slug)).sort();
}

checkUnique('source agents', sourceSlugs);

const antigravityDirs = expectedDirs('integrations/antigravity', agencySlugs);
checkExactSet(
  'antigravity',
  directEntries('integrations/antigravity', (entry) => entry.isDirectory() && entry.name.startsWith('agency-')),
  antigravityDirs,
  'integrations/antigravity/agency-*',
);
checkRequiredFiles('antigravity', antigravityDirs, ['SKILL.md']);

const geminiCliDirs = expectedDirs('integrations/gemini-cli/skills');
checkExactSet(
  'gemini-cli',
  directEntries('integrations/gemini-cli/skills', (entry) => entry.isDirectory()),
  geminiCliDirs,
  'integrations/gemini-cli/skills/*',
);
checkRequiredFiles('gemini-cli', geminiCliDirs, ['SKILL.md']);
if (!exists('integrations/gemini-cli/gemini-extension.json')) {
  fail('gemini-cli: missing integrations/gemini-cli/gemini-extension.json');
}
checkExactSet(
  'opencode',
  directEntries('integrations/opencode/agents', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  expectedFiles('integrations/opencode/agents', '.md'),
  'integrations/opencode/agents/*.md',
);
checkExactSet(
  'cursor',
  directEntries('integrations/cursor/rules', (entry) => entry.isFile() && entry.name.endsWith('.mdc')),
  expectedFiles('integrations/cursor/rules', '.mdc'),
  'integrations/cursor/rules/*.mdc',
);

const openclawDirs = expectedDirs('integrations/openclaw');
checkExactSet(
  'openclaw',
  directEntries('integrations/openclaw', (entry) => entry.isDirectory()),
  openclawDirs,
  'integrations/openclaw/*',
);
checkRequiredFiles('openclaw', openclawDirs, ['SOUL.md', 'AGENTS.md', 'IDENTITY.md']);

checkExactSet(
  'qwen',
  directEntries('integrations/qwen/agents', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  expectedFiles('integrations/qwen/agents', '.md'),
  'integrations/qwen/agents/*.md',
);
checkExactSet(
  'zcode',
  directEntries('integrations/zcode/agents', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  expectedFiles('integrations/zcode/agents', '.md'),
  'integrations/zcode/agents/*.md',
);

const kimiDirs = expectedDirs('integrations/kimi');
checkExactSet(
  'kimi',
  directEntries('integrations/kimi', (entry) => entry.isDirectory()),
  kimiDirs,
  'integrations/kimi/*',
);
checkRequiredFiles('kimi', kimiDirs, ['agent.yaml', 'system.md']);

checkExactSet(
  'codex',
  directEntries('integrations/codex/agents', (entry) => entry.isFile() && entry.name.endsWith('.toml')),
  expectedFiles('integrations/codex/agents', '.toml'),
  'integrations/codex/agents/*.toml',
);

const osaurusDirs = expectedDirs('integrations/osaurus', agencySlugs);
checkExactSet(
  'osaurus',
  directEntries('integrations/osaurus', (entry) => entry.isDirectory() && entry.name.startsWith('agency-')),
  osaurusDirs,
  'integrations/osaurus/agency-*',
);
checkRequiredFiles('osaurus', osaurusDirs, ['SKILL.md']);

checkExactSet(
  'vibe agents',
  directEntries('integrations/vibe/agents', (entry) => entry.isFile() && entry.name.endsWith('.toml')),
  expectedFiles('integrations/vibe/agents', '.toml'),
  'integrations/vibe/agents/*.toml',
);
checkExactSet(
  'vibe prompts',
  directEntries('integrations/vibe/prompts', (entry) => entry.isFile() && entry.name.endsWith('.md')),
  expectedFiles('integrations/vibe/prompts', '.md'),
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
  if (!Array.isArray(agents)) {
    fail(`${hermesData}: expected an array`);
  } else {
    const hermesSlugs = agents.map((agent) => agent.slug).sort();
    checkUnique('hermes', hermesSlugs);
    checkExactSet('hermes', hermesSlugs, sourceSlugs, hermesData);
  }
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
