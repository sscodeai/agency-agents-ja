#!/usr/bin/env node

const { execFileSync } = require('child_process');
const { existsSync, readdirSync, readFileSync } = require('fs');
const { join } = require('path');

const CATEGORIES = [
  'academic',
  'engineering',
  'project-management',
  'testing',
  'product',
  'marketing',
  'paid-media',
  'finance',
  'game-development',
  'gis',
  'healthcare',
  'hr',
  'design',
  'legal',
  'sales',
  'security',
  'spatial-computing',
  'support',
  'supply-chain',
  'research',
  'specialized',
];

const UPSTREAM_REF = process.env.UPSTREAM_REF || process.argv[2] || 'upstream/main';

function parseFrontmatter(file) {
  const text = readFileSync(file, 'utf8');
  const match = text.match(/^---\n([\s\S]*?)\n---/);
  if (!match) return {};
  const out = {};
  for (const line of match[1].split('\n')) {
    const idx = line.indexOf(':');
    if (idx === -1) continue;
    const key = line.slice(0, idx).trim();
    const value = line.slice(idx + 1).trim().replace(/^["']|["']$/g, '');
    out[key] = value;
  }
  return out;
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

function localUpstreamPaths() {
  const paths = [];
  for (const dir of CATEGORIES) {
    if (!existsSync(dir)) continue;
    for (const file of listMarkdownFiles(dir)) {
      const fm = parseFrontmatter(file);
      if (fm.source === 'upstream' && fm.upstream_path) {
        paths.push(fm.upstream_path);
      }
    }
  }
  return [...new Set(paths)].sort();
}

function upstreamAgentPaths() {
  const output = execFileSync('git', ['ls-tree', '-r', '--name-only', UPSTREAM_REF], {
    encoding: 'utf8',
  });
  const categorySet = new Set(CATEGORIES);
  return output
    .split('\n')
    .filter(Boolean)
    .filter(path => {
      if (!path.endsWith('.md')) return false;
      const dir = path.split('/')[0];
      return categorySet.has(dir);
    })
    .sort();
}

function difference(left, right) {
  const rightSet = new Set(right);
  return left.filter(item => !rightSet.has(item));
}

function printList(title, rows) {
  console.error(`\n${title}`);
  if (rows.length === 0) {
    console.error('  None');
    return;
  }
  for (const row of rows) {
    console.error(`  - ${row}`);
  }
}

let upstreamPaths;
try {
  upstreamPaths = upstreamAgentPaths();
} catch (error) {
  console.error(`Could not read upstream ref: ${UPSTREAM_REF}`);
  console.error('Fetch the upstream repository first, for example:');
  console.error('  git remote add upstream https://github.com/msitarzewski/agency-agents.git');
  console.error('  git fetch --depth=1 upstream main');
  process.exit(2);
}

const localPaths = localUpstreamPaths();
const missing = difference(upstreamPaths, localPaths);
const extra = difference(localPaths, upstreamPaths);

console.log(`Upstream ref: ${UPSTREAM_REF}`);
console.log(`Upstream agent paths: ${upstreamPaths.length}`);
console.log(`Local upstream_path values: ${localPaths.length}`);

if (missing.length > 0 || extra.length > 0) {
  console.error('\nUpstream parity check failed.');
  printList('Missing local upstream_path', missing);
  printList('Local upstream_path not found upstream', extra);
  process.exit(1);
}

console.log('Upstream parity check passed.');
