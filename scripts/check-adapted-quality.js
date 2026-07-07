#!/usr/bin/env node

const { existsSync, readdirSync, readFileSync } = require('fs');
const { basename, join } = require('path');

const CATEGORIES = [
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

const HIGH_RISK_SPECIALIZED = new Set([
  'agentic-identity-trust.md',
  'automation-governance-architect.md',
  'blockchain-security-auditor.md',
  'compliance-auditor.md',
  'healthcare-customer-service.md',
  'healthcare-marketing-compliance.md',
  'legal-billing-time-tracking.md',
  'legal-client-intake.md',
  'legal-document-review.md',
  'loan-officer-assistant.md',
  'zk-steward.md',
]);

function parseFrontmatter(text) {
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

function listAgentFiles() {
  return CATEGORIES.flatMap(dir => {
    if (!existsSync(dir)) return [];
    return listMarkdownFiles(dir);
  });
}

function isHighRisk(file) {
  const dir = file.split('/')[0];
  return dir === 'legal' || dir === 'finance' || HIGH_RISK_SPECIALIZED.has(basename(file));
}

const issues = [];

for (const file of listAgentFiles()) {
  const text = readFileSync(file, 'utf8');
  const fm = parseFrontmatter(text);

  if (fm.source === 'upstream' && fm.translation_status === 'skeleton') {
    issues.push(`${file}: upstream skeleton agents are not allowed in the maintained main branch`);
  }

  if (fm.source === 'upstream' && fm.translation_status === 'adapted' && !/^## Adapted 実務基準$/m.test(text)) {
    issues.push(`${file}: adapted upstream agent must include "## Adapted 実務基準"`);
  }

  if (isHighRisk(file) && !/^## 高リスク運用ガードレール$/m.test(text)) {
    issues.push(`${file}: high-risk agent must include "## 高リスク運用ガードレール"`);
  }
}

if (issues.length > 0) {
  console.error('Adapted quality check failed:');
  for (const issue of issues) {
    console.error(`- ${issue}`);
  }
  process.exit(1);
}

console.log('Adapted quality check passed.');
