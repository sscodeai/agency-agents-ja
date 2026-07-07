#!/usr/bin/env node

const { existsSync, readdirSync, readFileSync, writeFileSync } = require('fs');
const { join } = require('path');

const AGENT_CATEGORIES = [
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
  return files;
}

function computeStats() {
  let total = 0;
  let japan = 0;
  let upstream = 0;
  let skeleton = 0;
  let adapted = 0;

  for (const dir of AGENT_CATEGORIES) {
    if (!existsSync(dir)) continue;
    for (const file of listMarkdownFiles(dir)) {
      const fm = parseFrontmatter(file);
      total++;
      if (fm.source === 'japan-original') japan++;
      else if (fm.source === 'upstream') {
        upstream++;
        if (fm.translation_status === 'skeleton') skeleton++;
        else if (fm.translation_status === 'adapted') adapted++;
      }
    }
  }

  let workflows = 0;
  if (existsSync('workflows')) {
    workflows = readdirSync('workflows').filter(f => f.endsWith('.yaml') || f.endsWith('.yml')).length;
  }

  return { TOTAL: total, JAPAN: japan, UPSTREAM: upstream, SKELETON: skeleton, ADAPTED: adapted, WORKFLOWS: workflows };
}

function applyTokens(text, stats) {
  return text.replace(/<!-- AUTOGEN:(\w+) -->[\s\S]*?<!-- \/AUTOGEN:\1 -->/g, (match, token) => {
    if (!(token in stats)) {
      throw new Error(`Unknown AUTOGEN token: ${token}`);
    }
    return `<!-- AUTOGEN:${token} -->${stats[token]}<!-- /AUTOGEN:${token} -->`;
  });
}

const stats = computeStats();
const target = 'README.md';
const current = readFileSync(target, 'utf8');
const updated = applyTokens(current, stats);

if (process.argv.includes('--check')) {
  if (current !== updated) {
    console.error(`${target} stats are out of date. Run: node scripts/sync-readme-stats.js`);
    process.exit(1);
  }
  console.log(`${target} stats are up to date.`);
} else {
  if (current === updated) {
    console.log(`${target} stats already in sync.`);
  } else {
    writeFileSync(target, updated, 'utf8');
    console.log(`Updated ${target} stats: ${JSON.stringify(stats)}`);
  }
}
