#!/usr/bin/env node
'use strict';

/**
 * Guards the published agent counts against drift.
 *
 * The generated files (README.md AUTOGEN blocks, AGENT-LIST.md,
 * TRANSLATION-PROGRESS.md) already have their own --check generators, so this
 * script covers the gap those checks cannot see: *hand-written* numbers in
 * tracked markdown that still quote a retired catalog size.
 *
 * Why this exists: the repository description and three hand-written docs kept
 * saying "323 agents / 114 Japan-original" long after the catalog had grown to
 * 404 / 125. Generated blocks stayed correct, so every existing check passed
 * while the project was publicly describing itself with wrong numbers.
 *
 * Usage:
 *   node scripts/check-agent-counts.js
 *   node scripts/check-agent-counts.js --root <dir>     # check another tree
 *
 * A specific line that legitimately needs a retired number (for example a
 * migration note) can opt out with an inline marker:
 *   ... 323 agents ... <!-- allow-stale-count: predates the v0.4 catalog -->
 *
 * CHANGELOG.md is skipped entirely: it is a historical record, and rewriting
 * released history to satisfy a counter would be worse than the drift itself.
 */

const { existsSync, readFileSync, readdirSync } = require('fs');
const { join, relative } = require('path');

const { RETIRED_COUNTS, computeStats, describeStats } = require('./lib/agent-stats');

const ALLOW_MARKER = '<!-- allow-stale-count';
// `integrations/` holds generated mirrors of the agent catalog (thousands of
// files). Their consistency is already covered by check:generated-integrations,
// and they are rebuilt by convert.sh rather than hand-edited.
const SKIP_DIRS = new Set(['.git', 'node_modules', 'dist', 'build', '.astro', '.wrangler', '.pi', 'integrations']);
const SKIP_FILES = new Set(['CHANGELOG.md']);
const COUNT_NOUN = '(?:体|個|件|agents?|エージェント)';
// Allow a short modifier between the number and the noun so both
// "404 agents" and "125 japan-original agents" are recognised as claims.
const COUNT_PATTERN = `(?<![0-9.])(\\d{2,4})\\s*(?:[A-Za-z-]+\\s+){0,2}${COUNT_NOUN}`;

function argValue(flag) {
  const idx = process.argv.indexOf(flag);
  return idx === -1 ? undefined : process.argv[idx + 1];
}

function walk(dir, root, files = []) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (SKIP_DIRS.has(entry.name)) continue;
      walk(join(dir, entry.name), root, files);
    } else if (entry.isFile() && entry.name.endsWith('.md')) {
      const rel = relative(root, join(dir, entry.name));
      if (SKIP_FILES.has(rel) || SKIP_FILES.has(entry.name)) continue;
      files.push(rel);
    }
  }
  return files;
}

/** Retired counts used as agent counts, ignoring lines that opt out. */
function findRetiredCounts(files, root, stats) {
  const findings = [];
  const retired = new Set(Object.keys(RETIRED_COUNTS).map(Number));
  // A retired value that is also the current value is not drift.
  for (const value of Object.values(stats)) retired.delete(Number(value));
  if (retired.size === 0) return findings;

  const pattern = new RegExp(COUNT_PATTERN, 'g');

  for (const rel of files) {
    const text = readFileSync(join(root, rel), 'utf8');
    text.split('\n').forEach((line, index) => {
      if (line.includes(ALLOW_MARKER)) return;
      for (const match of line.matchAll(pattern)) {
        const value = Number(match[1]);
        if (!retired.has(value)) continue;
        findings.push({
          file: rel,
          line: index + 1,
          value,
          reason: RETIRED_COUNTS[value],
          text: line.trim(),
        });
      }
    });
  }
  return findings;
}

function main() {
  const root = argValue('--root') || process.cwd();

  if (!existsSync(join(root, 'README.md'))) {
    console.error(`check-agent-counts: no README.md in ${root}`);
    process.exit(1);
  }

  let files;
  try {
    files = walk(root, root);
  } catch (error) {
    console.error(`check-agent-counts: could not scan ${root}: ${error.message}`);
    process.exit(1);
  }

  const stats = computeStats(root);
  const findings = findRetiredCounts(files, root, stats);

  if (findings.length > 0) {
    console.error('Published agent counts contradict the catalog:');
    console.error('');
    for (const f of findings) {
      console.error(`  ${f.file}:${f.line}  ->  ${f.value} (${f.reason})`);
      console.error(`      ${f.text}`);
    }
    console.error('');
    console.error(`Current values: ${describeStats(stats)}.`);
    console.error('Fix the text, or mark the line with: <!-- allow-stale-count: <reason> -->');
    process.exit(1);
  }

  console.log(`Agent counts are consistent across ${files.length} markdown files: ${describeStats(stats)}.`);
}

main();
