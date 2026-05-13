#!/usr/bin/env node

const { existsSync, readdirSync, readFileSync, writeFileSync } = require('fs');

const CATEGORIES = [
  ['engineering', 'Engineering'],
  ['project-management', 'Project Management'],
  ['testing', 'Testing'],
  ['product', 'Product'],
  ['marketing', 'Marketing'],
  ['finance', 'Finance'],
  ['hr', 'HR'],
  ['design', 'Design'],
  ['legal', 'Legal'],
  ['sales', 'Sales'],
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

function listAgents() {
  const sections = [];
  for (const [dir, title] of CATEGORIES) {
    if (!existsSync(dir)) continue;
    const files = readdirSync(dir)
      .filter(name => name.endsWith('.md'))
      .sort();
    if (files.length === 0) continue;
    const rows = files.map(name => {
      const path = `${dir}/${name}`;
      const fm = parseFrontmatter(path);
      return { name: fm.name || name, description: fm.description || '', path };
    });
    sections.push({ title, rows });
  }
  return sections;
}

function render() {
  const sections = listAgents();
  const total = sections.reduce((sum, section) => sum + section.rows.length, 0);
  const lines = [
    '# Agent List',
    '',
    `Total agents: ${total}`,
    '',
  ];

  for (const section of sections) {
    lines.push(`## ${section.title}`, '');
    lines.push('| Name | Description | Path |');
    lines.push('| --- | --- | --- |');
    for (const row of section.rows) {
      lines.push(`| ${row.name} | ${row.description} | \`${row.path}\` |`);
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
