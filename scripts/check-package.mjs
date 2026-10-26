#!/usr/bin/env node
// Pack the published tarball, install it into a scratch consumer, and verify
// that the consumer receives the same agent bodies and no stray secrets.
//
// The publish tarball is produced by `npm publish`, which runs prepublishOnly →
// prepack. This script runs prepack first, then packs with --ignore-scripts so
// it verifies exactly the prepared tree that publish will ship.
import { execFileSync } from 'node:child_process';
import { existsSync, mkdtempSync, mkdirSync, readFileSync, readdirSync, rmSync, statSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import assert from 'node:assert/strict';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const manifest = JSON.parse(readFileSync(join(root, 'package.json'), 'utf8'));
const divisions = Object.keys(JSON.parse(readFileSync(join(root, 'divisions.json'), 'utf8')).divisions);
const scratch = mkdtempSync(join(tmpdir(), 'agency-agents-ja-package-'));
const env = { ...process.env, npm_config_cache: join(scratch, 'cache') };
const npm = process.platform === 'win32' ? 'npm.cmd' : 'npm';
// prepack prints conversion progress for 410 agents; the default 1 MB pipe
// buffer is not enough (spawnSync ENOBUFS).
const run = (args) => execFileSync(npm, args, {
  cwd: root,
  env,
  encoding: 'utf8',
  maxBuffer: 64 * 1024 * 1024,
});

function walkMarkdown(directory, prefix, out) {
  if (!existsSync(directory)) return;
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    if (entry.name.startsWith('.')) continue;
    const relative = join(prefix, entry.name);
    if (entry.isDirectory()) walkMarkdown(join(directory, entry.name), relative, out);
    else if (entry.isFile() && entry.name.endsWith('.md')) out.push(relative);
  }
}

try {
  // Prepare the same tree `npm publish` will pack (generate + conversions + validate).
  run(['run', 'prepack']);

  const destination = join(scratch, 'dist');
  mkdirSync(destination);
  // npm 10 prints an array of packs; npm 11/12 prints an object keyed by
  // package name. Accept both so the release job does not depend on the npm
  // version the runner installed.
  const packedOutput = JSON.parse(run([
    'pack', '--json', '--ignore-scripts', '--pack-destination', destination,
  ]));
  const packed = Array.isArray(packedOutput)
    ? packedOutput[0]
    : Object.values(packedOutput)[0];
  assert(packed && packed.filename, 'npm pack did not report a tarball filename');

  const installed = join(scratch, 'consumer');
  run([
    'install', '--prefix', installed, '--ignore-scripts', '--no-audit', '--no-fund',
    '--package-lock=false', join(destination, packed.filename),
  ]);

  const packageRoot = join(installed, 'node_modules', manifest.name);
  const received = JSON.parse(readFileSync(join(packageRoot, 'package.json'), 'utf8'));
  assert.equal(received.name, manifest.name);
  assert.equal(received.version, manifest.version);

  // Every source agent must arrive byte-for-byte unchanged.
  const agents = [];
  for (const division of divisions) {
    assert(existsSync(join(packageRoot, division)), `${division}/ is missing from the package`);
    walkMarkdown(join(root, division), division, agents);
  }
  let count = 0;
  for (const relative of agents) {
    const source = readFileSync(join(root, relative), 'utf8');
    const frontmatter = source.match(/^---\n([\s\S]*?)\n---/);
    if (!frontmatter || !/^name:/m.test(frontmatter[1])) continue;
    assert.equal(readFileSync(join(packageRoot, relative), 'utf8'), source, relative);
    count += 1;
  }

  for (const required of ['README.md', 'AGENT-LIST.md', 'divisions.json', 'LICENSE']) {
    assert(statSync(join(packageRoot, required)).isFile(), `${required} is missing from the package`);
  }
  assert(readFileSync(join(packageRoot, 'LICENSE'), 'utf8').includes('MIT'));
  for (const relative of Object.values(manifest.bin || {})) {
    assert(statSync(join(packageRoot, relative)).isFile(), `bin entry ${relative} is missing from the package`);
  }
  assert(
    !packed.files.some((file) => /(^|\/)(\.npmrc|\.env|node_modules)(\/|$)/.test(file.path)),
    'package contains .npmrc, .env, or node_modules',
  );

  console.log(`PASS: ${manifest.name}@${manifest.version} packs, installs, and ships ${count} agent bodies unchanged.`);
} finally {
  rmSync(scratch, { recursive: true, force: true });
}
