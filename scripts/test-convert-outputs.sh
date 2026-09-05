#!/usr/bin/env bash
#
# Regression test for generated integration outputs.
#
# It verifies the generated product, not only converter syntax: every tool emits
# the expected roster size, YAML/JSON outputs parse, descriptions round-trip,
# and the aggregate output manifest has not drifted unexpectedly.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST="$SCRIPT_DIR/convert-outputs.sha256"

UPDATE=false
OUT=""

for arg in "$@"; do
  case "$arg" in
    --update) UPDATE=true ;;
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

node - "$REPO_ROOT" "$OUT" "$MANIFEST" "$UPDATE" <<'NODE'
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const YAML = require('yaml');

const root = process.argv[2];
const out = process.argv[3];
const manifestPath = process.argv[4];
const update = process.argv[5] === 'true';

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

function aggregate(label, dir) {
  const base = path.join(out, dir);
  const files = listFiles(base, (file) => path.basename(file) !== 'README.md');
  const h = crypto.createHash('sha256');
  for (const file of files) {
    const rel = path.relative(base, file).split(path.sep).join('/');
    h.update(rel);
    h.update('\0');
    h.update(sha256(fs.readFileSync(file)));
    h.update('\n');
  }
  return `${h.digest('hex')}  ${label}`;
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
          description: String(fm.description),
        });
      }
    }
  }
}
agents.sort((a, b) => a.slug.localeCompare(b.slug));
const expected = agents.length;
const bySlug = new Map(agents.map((agent) => [agent.slug, agent]));

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

const manifest = [
  aggregate('aider', 'aider'),
  aggregate('antigravity', 'antigravity'),
  aggregate('codex', 'codex'),
  aggregate('cursor', 'cursor'),
  aggregate('gemini-cli', 'gemini-cli'),
  aggregate('hermes', 'hermes'),
  aggregate('kimi', 'kimi'),
  aggregate('opencode', 'opencode'),
  aggregate('openclaw', 'openclaw'),
  aggregate('osaurus', 'osaurus'),
  aggregate('qwen', 'qwen'),
  aggregate('vibe', 'vibe'),
  aggregate('windsurf', 'windsurf'),
  aggregate('zcode', 'zcode'),
  `${sha256(read(path.join(root, 'divisions.json')))}  contract:divisions.json`,
  `${sha256(read(path.join(root, 'tools.json')))}  contract:tools.json`,
].join('\n') + '\n';

if (update) {
  fs.writeFileSync(manifestPath, manifest, 'utf8');
} else if (!exists(manifestPath)) {
  fail('scripts/convert-outputs.sha256 is missing; run scripts/test-convert-outputs.sh --update');
} else {
  const current = read(manifestPath);
  if (current !== manifest) {
    fail('convert output manifest drifted; inspect changes and run scripts/test-convert-outputs.sh --update');
  }
}

if (errors > 0) process.exit(1);
console.log(`PASS: converted outputs parse and match ${expected} source agents`);
NODE
