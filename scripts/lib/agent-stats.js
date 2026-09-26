'use strict';

/**
 * Shared agent-library statistics.
 *
 * Single source of truth for every count that is published about this library:
 * README.md, AGENT-LIST.md, TRANSLATION-PROGRESS.md, the docs site, and the
 * repository description on GitHub.
 *
 * Scripts that generate counts and scripts that *verify* counts both import from
 * here so they can never disagree about how a count is derived.
 */

const { existsSync, readdirSync, readFileSync } = require('fs');
const { join } = require('path');

const AGENT_CATEGORIES = [
  'academic',
  'company',
  'engineering',
  'project-management',
  'testing',
  'product',
  'marketing',
  'paid-media',
  'research',
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

/**
 * Counts that were true at some point and must not be published again.
 *
 * These lived in the repository description and in three hand-written docs long
 * after the catalog had grown, which made the published numbers contradict the
 * generated ones. Keeping them here turns that class of drift into a CI failure.
 *
 * If a retired value ever becomes the real value again, the checker allows it and
 * tells you to remove it from this list.
 */
const RETIRED_COUNTS = {
  323: 'retired total (catalog held 323 agents)',
  394: 'retired total (catalog held 394 agents)',
  114: 'retired japan-original count',
  115: 'retired japan-original count',
  209: 'retired upstream-aligned count',
};

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

function computeStats(root = process.cwd()) {
  let total = 0;
  let japan = 0;
  let upstream = 0;
  let skeleton = 0;
  let adapted = 0;
  let categories = 0;

  for (const dir of AGENT_CATEGORIES) {
    const full = join(root, dir);
    if (!existsSync(full)) continue;
    categories++;
    for (const file of listMarkdownFiles(full)) {
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
  const workflowsDir = join(root, 'workflows');
  if (existsSync(workflowsDir)) {
    workflows = readdirSync(workflowsDir).filter(f => f.endsWith('.yaml') || f.endsWith('.yml')).length;
  }

  let tools = 0;
  const toolsFile = join(root, 'tools.json');
  if (existsSync(toolsFile)) {
    const registry = JSON.parse(readFileSync(toolsFile, 'utf8'));
    tools = Object.keys(registry.tools || {}).length;
  }

  return {
    TOTAL: total,
    JAPAN: japan,
    UPSTREAM: upstream,
    SKELETON: skeleton,
    ADAPTED: adapted,
    WORKFLOWS: workflows,
    CATEGORIES: categories,
    TOOLS: tools,
  };
}

function applyTokens(text, stats) {
  return text.replace(/<!-- AUTOGEN:(\w+) -->[\s\S]*?<!-- \/AUTOGEN:\1 -->/g, (match, token) => {
    if (!(token in stats)) {
      throw new Error(`Unknown AUTOGEN token: ${token}`);
    }
    return `<!-- AUTOGEN:${token} -->${stats[token]}<!-- /AUTOGEN:${token} -->`;
  });
}

/** Human-readable summary used in check output. */
function describeStats(stats) {
  return `total ${stats.TOTAL} (japan-original ${stats.JAPAN}, upstream-aligned ${stats.UPSTREAM})`;
}

module.exports = {
  AGENT_CATEGORIES,
  RETIRED_COUNTS,
  applyTokens,
  computeStats,
  describeStats,
  listMarkdownFiles,
  parseFrontmatter,
};
