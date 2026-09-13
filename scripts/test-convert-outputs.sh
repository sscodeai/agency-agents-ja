#!/usr/bin/env bash
#
# Regression test for generated integration outputs.
#
# It verifies the generated product, not only converter syntax: every tool emits
# the expected roster size, YAML/JSON outputs parse, descriptions round-trip,
# and the v2 output manifest has not drifted unexpectedly.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$SCRIPT_DIR/convert-outputs.sha256"

UPDATE=false
DRIFT=strict
OUT=""

for arg in "$@"; do
  case "$arg" in
    --update) UPDATE=true ;;
    --drift=advisory) DRIFT=advisory ;;
    --drift=strict) DRIFT=strict ;;
    --out=*) OUT="${arg#--out=}" ;;
    --help|-h)
      sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

command -v node >/dev/null 2>&1 || { echo "ERROR: node is required." >&2; exit 2; }

TMP=""
if [[ -z "$OUT" ]]; then
  TMP="$(mktemp -d "${TMPDIR:-/tmp}/agency-convert-outputs.XXXXXX")"
  trap 'rm -rf "$TMP"' EXIT
  OUT="$TMP"
  bash "$SCRIPT_DIR/convert.sh" --out "$OUT" --parallel --jobs 4 >/dev/null
fi

cd "$REPO_ROOT"

node - "$REPO_ROOT" "$OUT" "$MANIFEST" "$UPDATE" "$DRIFT" <<'NODE'
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const YAML = require('yaml');

const root = process.argv[2];
const out = process.argv[3];
const manifestPath = process.argv[4];
const update = process.argv[5] === 'true';
const advisoryDrift = process.argv[6] === 'advisory';

let errors = 0;
function fail(message) {
  console.error(`ERROR ${message}`);
  errors += 1;
}

function read(file) {
  return fs.readFileSync(file, 'utf8');
}

function exists(file) {
  return fs.existsSync(file);
}

function listFiles(dir, predicate = () => true, acc = []) {
  if (!exists(dir)) return acc;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) listFiles(full, predicate, acc);
    else if (entry.isFile() && predicate(full)) acc.push(full);
  }
  return acc.sort();
}

function directDirs(dir) {
  if (!exists(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .sort();
}

function directFiles(dir, suffix) {
  if (!exists(dir)) return [];
  return fs.readdirSync(dir, { withFileTypes: true })
    .filter((entry) => entry.isFile() && entry.name.endsWith(suffix))
    .map((entry) => entry.name)
    .sort();
}

function frontmatter(file) {
  const text = read(file);
  const match = text.match(/^---\n([\s\S]*?)\n---\n?/);
  if (!match) {
    fail(`${path.relative(root, file)}: missing YAML frontmatter`);
    return {};
  }
  try {
    return YAML.parse(match[1]) || {};
  } catch (error) {
    fail(`${path.relative(root, file)}: YAML parse failed: ${error.message}`);
    return {};
  }
}

function sha256(buffer) {
  return crypto.createHash('sha256').update(buffer).digest('hex');
}

const divisions = Object.keys(JSON.parse(read(path.join(root, 'divisions.json'))).divisions).sort();
const agents = [];
for (const division of divisions) {
  for (const file of listFiles(path.join(root, division), (f) => f.endsWith('.md'))) {
    if (read(file).startsWith('---\n')) {
      const fm = frontmatter(file);
      if (fm.name && fm.description) {
        agents.push({
          rel: path.relative(root, file).split(path.sep).join('/'),
          slug: path.basename(file, '.md'),
          agencySlug: `agency-${path.basename(file, '.md')}`,
          name: String(fm.name),
          description: String(fm.description),
        });
      }
    }
  }
}
agents.sort((a, b) => a.slug.localeCompare(b.slug));
const expected = agents.length;
const bySlug = new Map(agents.map((agent) => [agent.slug, agent]));
const byName = new Map(agents.map((agent) => [agent.name, agent.slug]));

function checkCount(label, actual) {
  if (actual !== expected) fail(`${label}: expected ${expected}, got ${actual}`);
}

function checkGeneratedFrontmatter(label, files, slugFromFile) {
  checkCount(label, files.length);
  for (const file of files) {
    const slug = slugFromFile(file);
    const source = bySlug.get(slug);
    if (!source) {
      fail(`${label}: unexpected generated file ${path.relative(out, file)}`);
      continue;
    }
    const fm = frontmatter(file);
    if (String(fm.description || '') !== source.description) {
      fail(`${label}/${slug}: description did not round-trip`);
    }
  }
}

checkGeneratedFrontmatter(
  'antigravity',
  directDirs(path.join(out, 'antigravity')).map((dir) => path.join(out, 'antigravity', dir, 'SKILL.md')),
  (file) => path.basename(path.dirname(file)).replace(/^agency-/, ''),
);

checkGeneratedFrontmatter(
  'gemini-cli',
  directDirs(path.join(out, 'gemini-cli', 'skills')).map((dir) => path.join(out, 'gemini-cli', 'skills', dir, 'SKILL.md')),
  (file) => path.basename(path.dirname(file)),
);

checkGeneratedFrontmatter(
  'opencode',
  directFiles(path.join(out, 'opencode', 'agents'), '.md').map((file) => path.join(out, 'opencode', 'agents', file)),
  (file) => path.basename(file, '.md'),
);

checkGeneratedFrontmatter(
  'cursor',
  directFiles(path.join(out, 'cursor', 'rules'), '.mdc').map((file) => path.join(out, 'cursor', 'rules', file)),
  (file) => path.basename(file, '.mdc'),
);

checkGeneratedFrontmatter(
  'qwen',
  directFiles(path.join(out, 'qwen', 'agents'), '.md').map((file) => path.join(out, 'qwen', 'agents', file)),
  (file) => path.basename(file, '.md'),
);

checkGeneratedFrontmatter(
  'zcode',
  directFiles(path.join(out, 'zcode', 'agents'), '.md').map((file) => path.join(out, 'zcode', 'agents', file)),
  (file) => path.basename(file, '.md'),
);

checkGeneratedFrontmatter(
  'osaurus',
  directDirs(path.join(out, 'osaurus')).map((dir) => path.join(out, 'osaurus', dir, 'SKILL.md')),
  (file) => path.basename(path.dirname(file)).replace(/^agency-/, ''),
);

checkCount('openclaw', directDirs(path.join(out, 'openclaw')).length);
checkCount('kimi', directDirs(path.join(out, 'kimi')).length);
checkCount('codex', directFiles(path.join(out, 'codex', 'agents'), '.toml').length);
checkCount('vibe agents', directFiles(path.join(out, 'vibe', 'agents'), '.toml').length);
checkCount('vibe prompts', directFiles(path.join(out, 'vibe', 'prompts'), '.md').length);

for (const dir of directDirs(path.join(out, 'kimi'))) {
  const yamlPath = path.join(out, 'kimi', dir, 'agent.yaml');
  if (!exists(yamlPath)) {
    fail(`kimi/${dir}: missing agent.yaml`);
    continue;
  }
  try {
    const parsed = YAML.parse(read(yamlPath));
    if (parsed?.agent?.name !== dir) fail(`kimi/${dir}: agent.yaml name mismatch`);
  } catch (error) {
    fail(`kimi/${dir}: agent.yaml parse failed: ${error.message}`);
  }
}

const geminiManifest = path.join(out, 'gemini-cli', 'gemini-extension.json');
if (exists(geminiManifest)) {
  try {
    JSON.parse(read(geminiManifest));
  } catch (error) {
    fail(`gemini-cli/gemini-extension.json parse failed: ${error.message}`);
  }
} else {
  fail('gemini-cli: missing gemini-extension.json');
}

const hermesAgents = path.join(out, 'hermes', 'agency-agents-router', 'data', 'agents.json');
if (exists(hermesAgents)) {
  try {
    const parsed = JSON.parse(read(hermesAgents));
    if (!Array.isArray(parsed)) fail('hermes agents.json is not an array');
    else checkCount('hermes', parsed.length);
  } catch (error) {
    fail(`hermes agents.json parse failed: ${error.message}`);
  }
} else {
  fail('hermes: missing data/agents.json');
}

for (const required of [
  ['aider', 'CONVENTIONS.md'],
  ['windsurf', '.windsurfrules'],
]) {
  if (!exists(path.join(out, ...required))) fail(`${required.join('/')}: missing`);
}

function normBuffer(buffer) {
  return Buffer.from(buffer.toString('utf8').replace(/\r\n/g, '\n'), 'utf8');
}

function relOut(file) {
  return path.relative(out, file).split(path.sep).join('/');
}

function digestEntries(entries) {
  const h = crypto.createHash('sha256');
  for (const [label, data] of entries.sort((a, b) => a[0].localeCompare(b[0]))) {
    h.update(label);
    h.update('\0');
    h.update(sha256(Buffer.isBuffer(data) ? data : Buffer.from(String(data))));
    h.update('\n');
  }
  return h.digest('hex');
}

const tools = [
  'aider',
  'antigravity',
  'codex',
  'cursor',
  'gemini-cli',
  'hermes',
  'kimi',
  'opencode',
  'openclaw',
  'osaurus',
  'qwen',
  'vibe',
  'windsurf',
  'zcode',
];
const slugs = new Set(agents.map((agent) => agent.slug));
const perAgent = new Map(agents.map((agent) => [agent.slug, []]));
const perTool = new Map(tools.map((tool) => [tool, []]));

function addAgent(slug, label, data) {
  if (!perAgent.has(slug)) perAgent.set(slug, []);
  perAgent.get(slug).push([label, data]);
}

function addTool(tool, label, data) {
  perTool.get(tool).push([label, data]);
}

function ownerOf(file) {
  const parts = relOut(file).split('/').slice(1);
  for (const component of parts.slice(0, -1)) {
    const maybe = component.startsWith('agency-') ? component.slice('agency-'.length) : component;
    if (slugs.has(maybe)) return maybe;
  }
  const stem = path.basename(parts[parts.length - 1], path.extname(parts[parts.length - 1]));
  return slugs.has(stem) ? stem : null;
}

function normalizeGeneratedReadme(data) {
  return data.replace(/^Generated agent count: \d+$/m, 'Generated agent count: N');
}

function splitAccumulatedTool(tool, file) {
  const lines = read(file).replace(/\r\n/g, '\n').split('\n');
  let currentSlug = null;
  let current = [];
  const preamble = [];
  function flush() {
    if (currentSlug) addAgent(currentSlug, `${tool}:section`, current.join('\n'));
  }
  for (const line of lines) {
    const maybeName = line.startsWith('## ') ? line.slice(3).trim() : null;
    const nextSlug = maybeName ? byName.get(maybeName) : null;
    if (nextSlug) {
      flush();
      currentSlug = nextSlug;
      current = [line];
      continue;
    }
    if (currentSlug) current.push(line);
    else preamble.push(line);
  }
  flush();
  addTool(tool, `${relOut(file)}:preamble`, preamble.join('\n'));
}

function addHermesAgentsJson(tool, file) {
  let parsed;
  try {
    parsed = JSON.parse(read(file));
  } catch {
    addTool(tool, relOut(file), normBuffer(fs.readFileSync(file)));
    return;
  }
  for (const item of parsed) {
    if (item?.slug && slugs.has(item.slug)) {
      addAgent(item.slug, `${tool}:entry`, JSON.stringify(item, Object.keys(item).sort()));
    } else {
      addTool(tool, `${relOut(file)}:stray-entry`, JSON.stringify(item));
    }
  }
}

for (const tool of tools) {
  for (const file of listFiles(path.join(out, tool))) {
    const rel = relOut(file);
    if ((tool === 'aider' && rel === 'aider/CONVENTIONS.md') || (tool === 'windsurf' && rel === 'windsurf/.windsurfrules')) {
      splitAccumulatedTool(tool, file);
      continue;
    }
    if (tool === 'hermes' && rel === 'hermes/agency-agents-router/data/agents.json') {
      addHermesAgentsJson(tool, file);
      continue;
    }
    const data = normBuffer(fs.readFileSync(file));
    const owner = ownerOf(file);
    if (owner) {
      addAgent(owner, rel, data);
    } else if (path.basename(file).toLowerCase() === 'readme.md') {
      addTool(tool, rel, normalizeGeneratedReadme(data.toString('utf8')));
    } else {
      addTool(tool, rel, data);
    }
  }
}

const manifestRows = [
  '# convert-outputs manifest v2 — one line per agent, one per non-agent tool output, one per contract.',
  '# Regenerate with: bash scripts/test-convert-outputs.sh --update',
];
for (const slug of [...slugs].sort()) {
  manifestRows.push(`agent\t${slug}\t${digestEntries(perAgent.get(slug) || [])}`);
}
for (const tool of tools) {
  manifestRows.push(`tool\t${tool}\t${digestEntries(perTool.get(tool) || [])}`);
}
for (const contract of ['divisions.json', 'tools.json']) {
  manifestRows.push(`contract\t${contract}\t${sha256(normBuffer(fs.readFileSync(path.join(root, contract))))}`);
}
const manifest = `${manifestRows.join('\n')}\n`;

function parseManifest(text) {
  const parsed = new Map();
  for (const line of text.split(/\r?\n/)) {
    if (!line || line.startsWith('#')) continue;
    const parts = line.split('\t');
    if (parts.length === 3) parsed.set(`${parts[0]}\t${parts[1]}`, parts[2]);
    else if (line.includes('  ')) return null;
  }
  return parsed;
}

function driftSummary(oldText) {
  const old = parseManifest(oldText);
  if (!old) return 'manifest is in old aggregate format; run scripts/test-convert-outputs.sh --update';
  const current = parseManifest(manifest);
  const added = [];
  const changed = [];
  const removed = [];
  for (const key of current.keys()) {
    if (!old.has(key)) added.push(key);
    else if (old.get(key) !== current.get(key)) changed.push(key);
  }
  for (const key of old.keys()) {
    if (!current.has(key)) removed.push(key);
  }
  if (!added.length && !changed.length && !removed.length) return '';
  const summarize = (label, values) => values.length ? `${label}: ${values.slice(0, 8).join(', ')}${values.length > 8 ? `, ... (${values.length} total)` : ''}` : '';
  return [summarize('added', added), summarize('changed', changed), summarize('removed', removed)].filter(Boolean).join('; ');
}

if (update) {
  fs.writeFileSync(manifestPath, manifest, 'utf8');
} else if (!exists(manifestPath)) {
  fail('scripts/convert-outputs.sha256 is missing; run scripts/test-convert-outputs.sh --update');
} else {
  const current = read(manifestPath);
  if (current !== manifest) {
    const summary = driftSummary(current);
    const message = `convert output manifest drifted${summary ? ` — ${summary}` : ''}; inspect changes and run scripts/test-convert-outputs.sh --update`;
    if (advisoryDrift) console.warn(`ADVISORY ${message}`);
    else fail(message);
  }
}

if (errors > 0) process.exit(1);
console.log(`PASS: converted outputs parse and match ${expected} source agents`);
NODE
