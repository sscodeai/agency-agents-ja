#!/usr/bin/env node

const { existsSync, readFileSync, readdirSync } = require('fs');
const { basename, dirname, join, resolve } = require('path');

const root = process.cwd();
const readmePath = join(root, 'README.md');

const knownPathRoots = new Set([
  '.github',
  'academic',
  'bin',
  'design',
  'docs',
  'engineering',
  'examples',
  'finance',
  'game-development',
  'gis',
  'healthcare',
  'hr',
  'integrations',
  'legal',
  'marketing',
  'paid-media',
  'product',
  'project-management',
  'research',
  'sales',
  'scripts',
  'security',
  'spatial-computing',
  'specialized',
  'strategy',
  'supply-chain',
  'support',
  'testing',
  'workflows',
]);

const bareFormatNames = new Set([
  'AGENTS.md',
  'CONVENTIONS.md',
  'IDENTITY.md',
  'SKILL.md',
  'SOUL.md',
  'convert.sh',
]);

const errors = [];

function fail(message) {
  errors.push(message);
}

function stripFragment(ref) {
  return ref.split('#')[0];
}

function isExternal(ref) {
  return /^[a-z][a-z0-9+.-]*:/i.test(ref) || ref.startsWith('#');
}

function cleanCodeRef(ref) {
  return ref
    .trim()
    .replace(/^["']|["']$/g, '')
    .replace(/[),.;:]+$/g, '');
}

function wildcardExists(relPath) {
  const dir = dirname(relPath);
  const pattern = basename(relPath)
    .replace(/[.+?^${}()|[\]\\]/g, '\\$&')
    .replace(/\*/g, '.*');
  const fullDir = resolve(root, dir);
  if (!existsSync(fullDir)) return false;
  const regex = new RegExp(`^${pattern}$`);
  return readdirSync(fullDir).some(entry => regex.test(entry));
}

function repoPathExists(relPath) {
  const normalized = stripFragment(relPath).replace(/^\.\//, '');
  if (!normalized) return true;
  if (normalized.includes('*')) return wildcardExists(normalized);
  return existsSync(resolve(root, normalized));
}

function isLikelyRepoPath(ref) {
  const normalized = stripFragment(ref).replace(/^\.\//, '');
  if (!normalized || normalized.includes(' ') || normalized.includes('{{')) return false;
  if (bareFormatNames.has(normalized)) return false;
  if (ref.startsWith('./')) return true;
  if (knownPathRoots.has(normalized.split('/')[0])) return true;
  if (/^[A-Z0-9_-]+\.(md|json|ya?ml|js|sh)$/i.test(normalized)) return true;
  return false;
}

if (!existsSync(readmePath)) {
  fail('README.md not found');
} else {
  const text = readFileSync(readmePath, 'utf8');

  for (const match of text.matchAll(/\[[^\]]+\]\(([^)]+)\)/g)) {
    const ref = match[1].trim();
    if (isExternal(ref)) continue;
    if (!repoPathExists(ref)) {
      fail(`README local link points to a missing path: ${ref}`);
    }
  }

  for (const match of text.matchAll(/`([^`\n]+)`/g)) {
    const ref = cleanCodeRef(match[1]);
    if (!isLikelyRepoPath(ref)) continue;
    if (!repoPathExists(ref)) {
      fail(`README inline path reference points to a missing path: ${ref}`);
    }
  }
}

if (errors.length > 0) {
  for (const error of errors) {
    console.error(`ERROR ${error}`);
  }
  console.error(`FAILED: ${errors.length} README reference error(s).`);
  process.exit(1);
}

console.log('PASSED: README local links and path references are valid.');
