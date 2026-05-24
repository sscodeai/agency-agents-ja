#!/usr/bin/env node

const { existsSync, readdirSync, readFileSync, writeFileSync } = require('fs');

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
  'hr',
  'design',
  'legal',
  'sales',
  'spatial-computing',
  'support',
  'supply-chain',
  'specialized',
];

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

function listAgents() {
  const rows = [];
  for (const dir of CATEGORIES) {
    if (!existsSync(dir)) continue;
    for (const file of readdirSync(dir).filter(name => name.endsWith('.md')).sort()) {
      const path = `${dir}/${file}`;
      const fm = parseFrontmatter(path);
      rows.push({
        path,
        source: fm.source || 'unknown',
        upstreamPath: fm.upstream_path || '',
        upstreamName: fm.upstream_name || '',
        status: fm.translation_status || '',
      });
    }
  }
  return rows;
}

function duplicates(values) {
  const counts = new Map();
  for (const value of values.filter(Boolean)) {
    counts.set(value, (counts.get(value) || 0) + 1);
  }
  return [...counts.entries()].filter(([, count]) => count > 1).map(([value]) => value).sort();
}

function renderList(title, rows, formatter) {
  if (rows.length === 0) return [`## ${title}`, '', 'None.', ''].join('\n');
  return [
    `## ${title}`,
    '',
    ...rows.map(formatter),
    '',
  ].join('\n');
}

function render() {
  const rows = listAgents();
  const upstreamRows = rows.filter(row => row.source === 'upstream');
  const japanRows = rows.filter(row => row.source === 'japan-original');
  const missingUpstreamPath = upstreamRows.filter(row => !row.upstreamPath);
  const invalidStatus = upstreamRows.filter(row => !['skeleton', 'translated', 'adapted'].includes(row.status));
  const duplicateUpstreamPaths = duplicates(upstreamRows.map(row => row.upstreamPath));
  const duplicateRows = upstreamRows.filter(row => duplicateUpstreamPaths.includes(row.upstreamPath));
  const japanWithUpstreamPath = japanRows.filter(row => row.upstreamPath);

  return [
    '# Upstream Coverage',
    '',
    'This file is generated from agent frontmatter. Do not edit it manually.',
    '',
    'Baseline: `msitarzewski/agency-agents@main` as of 2026-05-24 (declared in README.md).',
    '',
    `Total local agents: ${rows.length}`,
    `Japan-original agents: ${japanRows.length}`,
    `Upstream-aligned agents: ${upstreamRows.length}`,
    `Unique upstream paths: ${new Set(upstreamRows.map(row => row.upstreamPath).filter(Boolean)).size}`,
    `Missing upstream_path: ${missingUpstreamPath.length}`,
    `Invalid translation_status: ${invalidStatus.length}`,
    `Duplicate upstream_path groups: ${duplicateUpstreamPaths.length}`,
    '',
    renderList('Missing upstream_path', missingUpstreamPath, row => `- \`${row.path}\``),
    renderList('Invalid translation_status', invalidStatus, row => `- \`${row.path}\`: \`${row.status || '(missing)'}\``),
    renderList('Duplicate upstream_path', duplicateRows, row => `- \`${row.upstreamPath}\` -> \`${row.path}\``),
    renderList('Japan-original agents with upstream_path', japanWithUpstreamPath, row => `- \`${row.path}\``),
  ].join('\n');
}

const output = render();
const target = 'UPSTREAM-COVERAGE.md';
const rows = listAgents();
const upstreamRows = rows.filter(row => row.source === 'upstream');
const japanRows = rows.filter(row => row.source === 'japan-original');
const coverageIssues = [
  ...upstreamRows.filter(row => !row.upstreamPath),
  ...upstreamRows.filter(row => !['skeleton', 'translated', 'adapted'].includes(row.status)),
  ...japanRows.filter(row => row.upstreamPath),
];
const duplicateCount = duplicates(upstreamRows.map(row => row.upstreamPath)).length;

if (process.argv.includes('--check')) {
  const current = existsSync(target) ? readFileSync(target, 'utf8') : '';
  if (current !== output) {
    console.error(`${target} is out of date. Run: node scripts/check-upstream-coverage.js`);
    process.exit(1);
  }
  if (coverageIssues.length > 0 || duplicateCount > 0) {
    console.error(`${target} reports upstream coverage issues.`);
    process.exit(1);
  }
  console.log(`${target} is up to date.`);
} else {
  writeFileSync(target, output, 'utf8');
  console.log(`Wrote ${target}`);
}
