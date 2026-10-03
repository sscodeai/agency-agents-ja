#!/usr/bin/env node
'use strict';

/**
 * Guards against duplicate agent display names.
 *
 * Each agent file carries a human-readable `name:` in its frontmatter. Hosts
 * that register agents by display name (Claude Code, Codex, OpenClaw, ...)
 * cannot tell two agents with the same name apart: one silently shadows the
 * other, so the catalog looks larger than what the tool actually loads.
 *
 * Why this exists: the catalog had three pairs of duplicated names
 * (Baidu/Yahoo SEO, Douyin/TikTok, and two developer advocates) and no check
 * noticed, because every other guard keys on file paths or counts.
 *
 * Usage:
 *   node scripts/check-duplicate-names.js
 *   node scripts/check-duplicate-names.js --root <dir>   # check another tree
 */

const { existsSync, readFileSync, readdirSync } = require('fs');
const { join, relative } = require('path');

const AGENT_DIRS = [
  'academic',
  'company',
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

function argValue(flag) {
  const idx = process.argv.indexOf(flag);
  return idx === -1 ? undefined : process.argv[idx + 1];
}

/** Collect agent markdown files recursively (validate.sh uses find). */
function agentFiles(root, dir, acc = []) {
  const full = join(root, dir);
  if (!existsSync(full)) return acc;
  for (const entry of readdirSync(full, { withFileTypes: true })) {
    const rel = join(dir, entry.name);
    if (entry.isDirectory()) agentFiles(root, rel, acc);
    else if (entry.isFile() && entry.name.endsWith('.md')) acc.push(rel);
  }
  return acc;
}

function allAgentFiles(root) {
  const files = [];
  for (const dir of AGENT_DIRS) agentFiles(root, dir, files);
  return files.sort();
}

/** Read the frontmatter `name:` value, unquoting it like the shell helpers. */
function frontmatterName(text) {
  const lines = text.split('\n');
  if (lines[0] !== '---') return null;
  for (const line of lines.slice(1)) {
    if (line === '---') break;
    if (!line.startsWith('name:')) continue;
    let value = line.slice('name:'.length).trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    return value;
  }
  return null;
}

function main() {
  const root = argValue('--root') || process.cwd();

  const files = allAgentFiles(root);
  if (files.length === 0) {
    console.error(`check-duplicate-names: no agent files found under ${root}`);
    process.exit(1);
  }

  const byName = new Map();
  for (const rel of files) {
    const text = readFileSync(join(root, rel), 'utf8');
    const name = frontmatterName(text);
    if (!name) continue;
    if (!byName.has(name)) byName.set(name, []);
    byName.get(name).push(rel);
  }

  const duplicates = [...byName.entries()].filter(([, paths]) => paths.length > 1);

  if (duplicates.length > 0) {
    console.error('Duplicate agent display names break name-keyed hosts:');
    console.error('');
    for (const [name, paths] of duplicates.sort((a, b) => a[0].localeCompare(b[0]))) {
      console.error(`  "${name}"`);
      for (const path of paths) console.error(`      ${path}`);
    }
    console.error('');
    console.error('Give each agent a unique `name:` in its frontmatter.');
    process.exit(1);
  }

  console.log(`Agent names are unique across ${files.length} files.`);
}

main();
