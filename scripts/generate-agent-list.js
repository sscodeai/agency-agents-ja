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
  const sections = [];
  for (const [dir, title] of CATEGORIES) {
    if (!existsSync(dir)) continue;
    const files = listMarkdownFiles(dir);
    if (files.length === 0) continue;
    const rows = files.map(path => {
      const fm = parseFrontmatter(path);
      return {
        name: fm.name || path,
        description: fm.description || '',
        path,
        source: fm.source || 'unknown',
        upstreamName: fm.upstream_name || '',
        upstreamPath: fm.upstream_path || '',
        translationStatus: fm.translation_status || '',
      };
    });
    sections.push({ dir, title, rows });
  }
  return sections;
}

function countBySource(sections) {
  let upstream = 0;
  let japan = 0;
  let unknown = 0;
  for (const section of sections) {
    for (const row of section.rows) {
      if (row.source === 'upstream') upstream++;
      else if (row.source === 'japan-original') japan++;
      else unknown++;
    }
  }
  return { upstream, japan, unknown, total: upstream + japan + unknown };
}

function render() {
  const sections = listAgents();
  const counts = countBySource(sections);

  const lines = [
    '# Agent List',
    '',
    `Total agents: ${counts.total} (⭐ ${counts.japan} japan-original + ${counts.upstream} upstream-aligned${counts.unknown ? ` + ${counts.unknown} unclassified` : ''})`,
    '',
    '⭐ = Japan-market original agent (independently designed for Japanese IT / SaaS / SIer / 製造業 DX / 公共 sector workflows).',
    'Other rows = upstream-aligned agents derived from [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents), tracked with `source`, `upstream_path`, and `translation_status` frontmatter.',
    '',
  ];

  for (const section of sections) {
    const japanRows = section.rows.filter(r => r.source === 'japan-original');
    const upstreamRows = section.rows.filter(r => r.source !== 'japan-original');
    const total = section.rows.length;
    lines.push(`## ${section.title}`, '');
    lines.push(`Total: ${total} (⭐ ${japanRows.length} japan-original + ${upstreamRows.length} upstream-aligned)`, '');
    lines.push('| | Name | Source | Status | Upstream | Description | Path |');
    lines.push('| --- | --- | --- | --- | --- | --- | --- |');
    for (const row of japanRows) {
      lines.push(`| ⭐ | ${row.name} | japan-original |  |  | ${row.description} | \`${row.path}\` |`);
    }
    for (const row of upstreamRows) {
      lines.push(`|  | ${row.name} | upstream | ${row.translationStatus || 'unknown'} | ${row.upstreamName || row.upstreamPath || ''} | ${row.description} | \`${row.path}\` |`);
    }
    lines.push('');
  }

  return lines.join('\n').replace(/\n+$/, '\n');
}

const output = render();
const target = 'AGENT-LIST.md';
if (process.argv.includes('--check')) {
  const current = existsSync(target) ? readFileSync(target, 'utf8') : '';
  if (current !== output) {
    console.error(`${target} is out of date. Run: node scripts/generate-agent-list.js`);
    process.exit(1);
  }
  console.log(`${target} is up to date.`);
} else {
  writeFileSync(target, output, 'utf8');
  console.log(`Wrote ${target}`);
}
