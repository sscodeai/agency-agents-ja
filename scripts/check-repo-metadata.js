#!/usr/bin/env node
'use strict';

/**
 * Guards the one published count that lives outside git: the repository
 * description on GitHub.
 *
 * Why this exists: every in-repo check can pass while the repository describes
 * itself with retired numbers. That is exactly what happened — README.md said
 * 404 agents while the description still advertised 323, and nothing failed.
 *
 * The check only validates *numbers*, never wording, so the description can be
 * reworded freely as long as any agent count it quotes is current. Omitting
 * counts entirely is also allowed.
 *
 * Usage:
 *   node scripts/check-repo-metadata.js                     # check (tolerates no network)
 *   node scripts/check-repo-metadata.js --strict            # fail if the API cannot be read (CI)
 *   node scripts/check-repo-metadata.js --description "..." # check a string, no network
 *   node scripts/check-repo-metadata.js --fix               # PATCH the description (needs a token)
 *
 * `--fix` needs a token with repository administration rights, so run it locally
 * with `gh auth token`; the GitHub Actions token cannot do it.
 */

const { execFileSync } = require('child_process');

const { RETIRED_COUNTS, computeStats, describeStats } = require('./lib/agent-stats');

const COUNT_NOUN = '(?:体|個|件|agents?|エージェント)';
// Allow a short modifier between the number and the noun so both
// "404 agents" and "125 japan-original agents" are recognised as claims.
const COUNT_PATTERN = new RegExp(`(?<![0-9.])(\\d{2,4})\\s*(?:[A-Za-z-]+\\s+){0,2}${COUNT_NOUN}`, 'g');

function argValue(flag) {
  const idx = process.argv.indexOf(flag);
  return idx === -1 ? undefined : process.argv[idx + 1];
}

function flag(flagName) {
  return process.argv.includes(flagName);
}

function currentDescription(stats) {
  return `${stats.TOTAL}体の即戦力AI専門エージェント集 — Claude Code / Cursor / Copilot 等に対応。`
    + `日本市場向けオリジナル${stats.JAPAN}体（SIer・受託開発・SaaS・製造DX・公共分野）。`
    + 'agency-agentsの日本語コミュニティ版';
}

function repoSlug() {
  if (process.env.GITHUB_REPOSITORY) return process.env.GITHUB_REPOSITORY;
  const url = execFileSync('git', ['remote', 'get-url', 'origin'], { encoding: 'utf8' }).trim();
  const match = url.match(/github\.com[:/]([^/]+\/[^/\s]+?)(?:\.git)?$/);
  return match ? match[1] : null;
}

async function fetchDescription(repo) {
  const headers = { 'User-Agent': 'agency-agents-ja-count-check', Accept: 'application/vnd.github+json' };
  const token = process.env.GITHUB_TOKEN || process.env.GH_TOKEN;
  if (token) headers.Authorization = `Bearer ${token}`;
  const response = await fetch(`https://api.github.com/repos/${repo}`, { headers });
  if (!response.ok) {
    throw new Error(`GET /repos/${repo} returned ${response.status}`);
  }
  const body = await response.json();
  return body.description || '';
}

function findProblems(description, stats) {
  const problems = [];
  const retired = new Set(Object.keys(RETIRED_COUNTS).map(Number));
  for (const value of Object.values(stats)) retired.delete(Number(value));

  for (const match of description.matchAll(COUNT_PATTERN)) {
    const value = Number(match[1]);
    if (retired.has(value)) {
      problems.push({ value, text: match[0].trim(), reason: RETIRED_COUNTS[value] });
    }
  }
  return problems;
}

async function main() {
  const stats = computeStats();
  const inline = argValue('--description');

  if (inline !== undefined) {
    const problems = findProblems(inline, stats);
    if (problems.length > 0) {
      console.error('Description quotes retired agent counts:');
      for (const p of problems) console.error(`  ${p.value} (${p.reason}): "${p.text}"`);
      console.error(`Current values: ${describeStats(stats)}.`);
      process.exit(1);
    }
    console.log(`Description counts are current: ${describeStats(stats)}.`);
    return;
  }

  const repo = repoSlug();
  if (!repo) {
    console.error('check-repo-metadata: could not determine the GitHub repository (no origin remote?).');
    process.exit(flag('--strict') ? 1 : 0);
  }

  let description;
  try {
    description = await fetchDescription(repo);
  } catch (error) {
    const message = `check-repo-metadata: could not read the description of ${repo}: ${error.message}`;
    if (flag('--strict')) {
      console.error(message);
      process.exit(1);
    }
    console.log(`${message} (skipped)`);
    return;
  }

  const problems = findProblems(description, stats);

  if (problems.length > 0) {
    console.error(`The repository description of ${repo} quotes retired agent counts:`);
    console.error('');
    for (const p of problems) {
      console.error(`  ${p.value} (${p.reason})`);
    }
    console.error('');
    console.error(`Current values: ${describeStats(stats)}.`);
    console.error('');
    console.error('Current description:');
    console.error(`  ${description}`);
    console.error('');
    console.error('Suggested replacement:');
    console.error(`  ${currentDescription(stats)}`);
    console.error('');
    console.error('Apply it with:');
    console.error(`  gh api -X PATCH repos/${repo} -f description="${currentDescription(stats)}"`);
    console.error('  # or: node scripts/check-repo-metadata.js --fix');
    process.exit(1);
  }

  if (flag('--fix')) {
    const desired = currentDescription(stats);
    if (desired === description) {
      console.log('Repository description already matches the generated counts.');
      return;
    }
    const token = process.env.GITHUB_TOKEN || process.env.GH_TOKEN;
    if (!token) {
      console.error('check-repo-metadata --fix needs GITHUB_TOKEN (bash: export GITHUB_TOKEN=$(gh auth token))');
      process.exit(1);
    }
    const response = await fetch(`https://api.github.com/repos/${repo}`, {
      method: 'PATCH',
      headers: {
        Authorization: `Bearer ${token}`,
        Accept: 'application/vnd.github+json',
        'User-Agent': 'agency-agents-ja-count-check',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ description: desired }),
    });
    if (!response.ok) {
      console.error(`check-repo-metadata: PATCH failed with ${response.status}`);
      process.exit(1);
    }
    console.log('Updated the repository description.');
    return;
  }

  console.log(`Repository description of ${repo} quotes current counts only (${describeStats(stats)}).`);
}

main().catch(error => {
  console.error(`check-repo-metadata: ${error.message}`);
  process.exit(1);
});
