#!/usr/bin/env node

const { existsSync, readdirSync, readFileSync, writeFileSync } = require('fs');
const { join } = require('path');

const CATEGORIES = [
  ['academic', 'Academic'],
  ['engineering', 'Engineering'],
  ['project-management', 'Project Management'],
  ['testing', 'Testing'],
  ['product', 'Product'],
  ['marketing', 'Marketing'],
  ['paid-media', 'Paid Media'],
  ['finance', 'Finance'],
  ['game-development', 'Game Development'],
  ['hr', 'HR'],
  ['design', 'Design'],
  ['legal', 'Legal'],
  ['sales', 'Sales'],
  ['security', 'Security'],
  ['spatial-computing', 'Spatial Computing'],
  ['support', 'Support'],
  ['supply-chain', 'Supply Chain'],
  ['specialized', 'Specialized'],
];

const STATUS_ORDER = ['skeleton', 'translated', 'adapted'];

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

function listAgents() {
  const rows = [];
  for (const [dir, title] of CATEGORIES) {
    if (!existsSync(dir)) continue;
    for (const path of listMarkdownFiles(dir)) {
      const fm = parseFrontmatter(path);
      rows.push({
        category: title,
        path,
        name: fm.name || path,
        source: fm.source || 'unknown',
        upstreamName: fm.upstream_name || '',
        upstreamPath: fm.upstream_path || '',
        status: fm.translation_status || '',
      });
    }
  }
  return rows;
}

function count(rows, predicate) {
  return rows.filter(predicate).length;
}

function renderStatusTable(rows) {
  const lines = [
    '| Category | Upstream | Skeleton | Translated | Adapted | Japan-original |',
    '| --- | ---: | ---: | ---: | ---: | ---: |',
  ];

  for (const [, title] of CATEGORIES) {
    const categoryRows = rows.filter(row => row.category === title);
    if (categoryRows.length === 0) continue;
    lines.push([
      `| ${title}`,
      count(categoryRows, row => row.source === 'upstream'),
      count(categoryRows, row => row.status === 'skeleton'),
      count(categoryRows, row => row.status === 'translated'),
      count(categoryRows, row => row.status === 'adapted'),
      count(categoryRows, row => row.source === 'japan-original'),
    ].join(' | ') + ' |');
  }

  return lines.join('\n');
}

function renderBacklog(rows) {
  const skeletonRows = rows
    .filter(row => row.source === 'upstream' && row.status === 'skeleton')
    .sort((a, b) => a.path.localeCompare(b.path));

  const lines = [
    '| Agent | Upstream | Path |',
    '| --- | --- | --- |',
  ];

  for (const row of skeletonRows) {
    lines.push(`| ${row.name} | ${row.upstreamName || row.upstreamPath || ''} | \`${row.path}\` |`);
  }

  return lines.join('\n');
}

function render() {
  const rows = listAgents();
  const total = rows.length;
  const upstream = count(rows, row => row.source === 'upstream');
  const japan = count(rows, row => row.source === 'japan-original');
  const statusCounts = Object.fromEntries(STATUS_ORDER.map(status => [status, count(rows, row => row.status === status)]));

  return [
    '# Translation Progress',
    '',
    'This file is generated from agent frontmatter. Do not edit it manually.',
    '',
    `Total agents: ${total}`,
    `Japan-original agents: ${japan}`,
    `Upstream-aligned agents: ${upstream}`,
    `Skeleton: ${statusCounts.skeleton}`,
    `Translated: ${statusCounts.translated}`,
    `Adapted: ${statusCounts.adapted}`,
    '',
    '## By Category',
    '',
    renderStatusTable(rows),
    '',
    '## Skeleton Backlog',
    '',
    renderBacklog(rows),
    '',
  ].join('\n');
}

const output = render();
const target = 'TRANSLATION-PROGRESS.md';
if (process.argv.includes('--check')) {
  const current = existsSync(target) ? readFileSync(target, 'utf8') : '';
  if (current !== output) {
    console.error(`${target} is out of date. Run: node scripts/generate-translation-progress.js`);
    process.exit(1);
  }
  console.log(`${target} is up to date.`);
} else {
  writeFileSync(target, output, 'utf8');
  console.log(`Wrote ${target}`);
}
