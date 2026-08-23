#!/usr/bin/env node

const { execFileSync } = require('child_process');
const { mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } = require('fs');
const { tmpdir } = require('os');
const { join, resolve } = require('path');

const root = resolve(__dirname, '..');

function run(command, args, options = {}) {
  return execFileSync(command, args, {
    cwd: options.cwd || root,
    encoding: 'utf8',
    stdio: options.stdio || 'pipe',
  });
}

function writeAgent(baseDir, relPath, body) {
  const fullPath = join(baseDir, relPath);
  mkdirSync(join(fullPath, '..'), { recursive: true });
  writeFileSync(fullPath, body, 'utf8');
}

function minimalAgent({ status = 'adapted', adaptedSection = true, guardrail = false } = {}) {
  return [
    '---',
    'name: テスト agent',
    'description: テスト用 agent。',
    'emoji: 🧪',
    'color: blue',
    'source: upstream',
    'upstream_path: legal/test-agent.md',
    'upstream_name: Test Agent',
    `translation_status: ${status}`,
    '---',
    '',
    '# テスト agent',
    '',
    '## 役割',
    '',
    'テスト用です。',
    '',
    adaptedSection ? '## Adapted 実務基準' : '',
    adaptedSection ? '' : '',
    adaptedSection ? '- テスト基準を確認してください。' : '',
    '',
    guardrail ? '## 高リスク運用ガードレール' : '',
    guardrail ? '' : '',
    guardrail ? '- 高リスク時は escalation してください。' : '',
    '',
  ].filter(line => line !== '').join('\n');
}

function expectPass(name, fn) {
  try {
    fn();
    console.log(`PASS ${name}`);
  } catch (error) {
    console.error(`FAIL ${name}`);
    if (error.stdout) console.error(error.stdout.toString());
    if (error.stderr) console.error(error.stderr.toString());
    throw error;
  }
}

function expectFail(name, fn, expectedText) {
  try {
    fn();
  } catch (error) {
    const output = `${error.stdout || ''}${error.stderr || ''}`;
    if (!output.includes(expectedText)) {
      console.error(`FAIL ${name}`);
      console.error(`Expected output to include: ${expectedText}`);
      console.error(output);
      throw error;
    }
    console.log(`PASS ${name}`);
    return;
  }
  throw new Error(`Expected failure: ${name}`);
}

expectPass('maintenance scripts parse as valid JavaScript', () => {
  run('node', ['--check', 'scripts/check-adapted-quality.js']);
  run('node', ['--check', 'scripts/check-generated-integrations.js']);
  run('node', ['--check', 'scripts/check-package-files.js']);
  run('node', ['--check', 'scripts/check-readme-references.js']);
  run('node', ['--check', 'scripts/check-upstream-parity.js']);
  run('node', ['--check', 'scripts/sync-readme-stats.js']);
  run('node', ['--check', 'scripts/validate-workflows.js']);
});

const readmeFixture = mkdtempSync(join(tmpdir(), 'agency-agents-ja-readme-'));

try {
  expectPass('README reference check accepts existing local links and repo paths', () => {
    mkdirSync(join(readmeFixture, 'docs'), { recursive: true });
    mkdirSync(join(readmeFixture, 'workflows'), { recursive: true });
    writeFileSync(join(readmeFixture, 'docs/guide.md'), '# Guide\n', 'utf8');
    writeFileSync(join(readmeFixture, 'workflows/demo.yaml'), 'name: demo\n', 'utf8');
    writeFileSync(join(readmeFixture, 'README.md'), [
      '# Fixture',
      '',
      'See [guide](docs/guide.md) and `workflows/demo.yaml`.',
      'Generated formats like `SOUL.md` and helper names like `convert.sh` are descriptive.',
      '',
    ].join('\n'), 'utf8');
    run('node', [join(root, 'scripts/check-readme-references.js')], { cwd: readmeFixture });
  });

  expectFail('README reference check rejects missing local links', () => {
    writeFileSync(join(readmeFixture, 'README.md'), [
      '# Fixture',
      '',
      'Broken link: [missing](docs/missing.md).',
      '',
    ].join('\n'), 'utf8');
    run('node', [join(root, 'scripts/check-readme-references.js')], { cwd: readmeFixture });
  }, 'README local link points to a missing path');

  expectFail('README reference check rejects missing inline repo paths', () => {
    writeFileSync(join(readmeFixture, 'README.md'), [
      '# Fixture',
      '',
      'Broken inline path: `workflows/missing.yaml`.',
      '',
    ].join('\n'), 'utf8');
    run('node', [join(root, 'scripts/check-readme-references.js')], { cwd: readmeFixture });
  }, 'README inline path reference points to a missing path');
} finally {
  rmSync(readmeFixture, { recursive: true, force: true });
}

const statsFixture = mkdtempSync(join(tmpdir(), 'agency-agents-ja-stats-'));

try {
  expectPass('README stats sync updates category, tool, workflow, and agent counts', () => {
    writeAgent(statsFixture, 'academic/japan-original.md', [
      '---',
      'name: 日本 original',
      'description: Fixture original agent。',
      'emoji: 🧪',
      'color: blue',
      'source: japan-original',
      '---',
      '',
      '# 日本 original',
      '',
    ].join('\n'));
    writeAgent(statsFixture, 'engineering/upstream-agent.md', minimalAgent());
    mkdirSync(join(statsFixture, 'workflows'), { recursive: true });
    writeFileSync(join(statsFixture, 'workflows/demo.yaml'), 'name: demo\n', 'utf8');
    writeFileSync(join(statsFixture, 'tools.json'), JSON.stringify({
      tools: {
        first: {},
        second: {},
      },
    }), 'utf8');
    writeFileSync(join(statsFixture, 'README.md'), [
      '# Fixture',
      '',
      '<!-- AUTOGEN:TOTAL -->0<!-- /AUTOGEN:TOTAL -->',
      '<!-- AUTOGEN:JAPAN -->0<!-- /AUTOGEN:JAPAN -->',
      '<!-- AUTOGEN:UPSTREAM -->0<!-- /AUTOGEN:UPSTREAM -->',
      '<!-- AUTOGEN:SKELETON -->0<!-- /AUTOGEN:SKELETON -->',
      '<!-- AUTOGEN:ADAPTED -->0<!-- /AUTOGEN:ADAPTED -->',
      '<!-- AUTOGEN:WORKFLOWS -->0<!-- /AUTOGEN:WORKFLOWS -->',
      '<!-- AUTOGEN:CATEGORIES -->0<!-- /AUTOGEN:CATEGORIES -->',
      '<!-- AUTOGEN:TOOLS -->0<!-- /AUTOGEN:TOOLS -->',
      '',
    ].join('\n'), 'utf8');

    run('node', [join(root, 'scripts/sync-readme-stats.js')], { cwd: statsFixture });
    run('node', [join(root, 'scripts/sync-readme-stats.js'), '--check'], { cwd: statsFixture });
    const readme = readFileSync(join(statsFixture, 'README.md'), 'utf8');
    for (const expected of [
      '<!-- AUTOGEN:TOTAL -->2<!-- /AUTOGEN:TOTAL -->',
      '<!-- AUTOGEN:JAPAN -->1<!-- /AUTOGEN:JAPAN -->',
      '<!-- AUTOGEN:UPSTREAM -->1<!-- /AUTOGEN:UPSTREAM -->',
      '<!-- AUTOGEN:ADAPTED -->1<!-- /AUTOGEN:ADAPTED -->',
      '<!-- AUTOGEN:WORKFLOWS -->1<!-- /AUTOGEN:WORKFLOWS -->',
      '<!-- AUTOGEN:CATEGORIES -->2<!-- /AUTOGEN:CATEGORIES -->',
      '<!-- AUTOGEN:TOOLS -->2<!-- /AUTOGEN:TOOLS -->',
    ]) {
      if (!readme.includes(expected)) {
        throw new Error(`Expected README stats to include ${expected}`);
      }
    }
  });
} finally {
  rmSync(statsFixture, { recursive: true, force: true });
}

const fixture = mkdtempSync(join(tmpdir(), 'agency-agents-ja-maintenance-'));

try {
  expectPass('adapted quality check accepts compliant high-risk agents', () => {
    writeAgent(fixture, 'legal/test-agent.md', minimalAgent({ guardrail: true }));
    run('node', [join(root, 'scripts/check-adapted-quality.js')], { cwd: fixture });
  });

  expectFail('adapted quality check rejects missing adapted section', () => {
    writeAgent(fixture, 'legal/test-agent.md', minimalAgent({ adaptedSection: false, guardrail: true }));
    run('node', [join(root, 'scripts/check-adapted-quality.js')], { cwd: fixture });
  }, 'must include "## Adapted 実務基準"');

  expectFail('adapted quality check rejects missing high-risk guardrail', () => {
    writeAgent(fixture, 'legal/test-agent.md', minimalAgent({ guardrail: false }));
    run('node', [join(root, 'scripts/check-adapted-quality.js')], { cwd: fixture });
  }, 'must include "## 高リスク運用ガードレール"');

  expectFail('adapted quality check rejects skeleton upstream agents', () => {
    writeAgent(fixture, 'legal/test-agent.md', minimalAgent({ status: 'skeleton', guardrail: true }));
    run('node', [join(root, 'scripts/check-adapted-quality.js')], { cwd: fixture });
  }, 'upstream skeleton agents are not allowed');
} finally {
  rmSync(fixture, { recursive: true, force: true });
}

function writeWorkflowFixture(baseDir, workflowText, exampleText = workflowText) {
  mkdirSync(join(baseDir, 'workflows'), { recursive: true });
  mkdirSync(join(baseDir, 'examples'), { recursive: true });
  mkdirSync(join(baseDir, 'engineering'), { recursive: true });
  writeFileSync(join(baseDir, 'engineering/test-agent.md'), minimalAgent(), 'utf8');
  writeFileSync(join(baseDir, 'workflows/test-workflow.yaml'), workflowText, 'utf8');
  writeFileSync(join(baseDir, 'examples/workflow-test.md'), [
    '# Workflow Test',
    '',
    '```yaml',
    exampleText.trim(),
    '```',
    '',
  ].join('\n'), 'utf8');
}

const validWorkflow = `
name: test-workflow
description: Test workflow
agents_dir: "."
inputs:
  - name: request
    required: true
steps:
  - id: first
    role: "engineering/test-agent"
    task: "Review {{request}}."
    output: first_output
  - id: second
    role: "engineering/test-agent"
    task: "Use {{first_output}}."
    depends_on: [first]
    output: summary
`;

const workflowFixture = mkdtempSync(join(tmpdir(), 'agency-agents-ja-workflows-'));

try {
  expectPass('workflow validator accepts structured YAML workflows', () => {
    writeWorkflowFixture(workflowFixture, validWorkflow);
    run('node', [join(root, 'scripts/validate-workflows.js')], { cwd: workflowFixture });
  });

  expectFail('workflow validator rejects non-prior dependencies', () => {
    writeWorkflowFixture(workflowFixture, `
name: test-workflow
description: Test workflow
agents_dir: "."
steps:
  - id: first
    role: "engineering/test-agent"
    task: "Use later."
    depends_on: [second]
    output: first_output
  - id: second
    role: "engineering/test-agent"
    task: "Run second."
    output: summary
`);
    run('node', [join(root, 'scripts/validate-workflows.js')], { cwd: workflowFixture });
  }, 'depends on non-prior step');

  expectFail('workflow validator rejects unavailable placeholders', () => {
    writeWorkflowFixture(workflowFixture, `
name: test-workflow
description: Test workflow
agents_dir: "."
steps:
  - id: first
    role: "engineering/test-agent"
    task: "Use {{missing_input}}."
    output: summary
`);
    run('node', [join(root, 'scripts/validate-workflows.js')], { cwd: workflowFixture });
  }, 'references unavailable placeholder');
} finally {
  rmSync(workflowFixture, { recursive: true, force: true });
}

console.log('Maintenance script tests passed.');
