#!/usr/bin/env node

const { readFileSync, writeFileSync } = require('fs');

const { applyTokens, computeStats } = require('./lib/agent-stats');

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
