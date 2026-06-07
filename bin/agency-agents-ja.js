#!/usr/bin/env node

const { existsSync, readFileSync } = require('fs');
const { resolve, dirname } = require('path');
const { spawnSync } = require('child_process');

const root = resolve(__dirname, '..');
const pkg = JSON.parse(readFileSync(resolve(root, 'package.json'), 'utf8'));

function help() {
  console.log(`agency-agents-ja ${pkg.version}

Usage:
  agency-agents-ja install [options]   Install agents for detected tools
  agency-agents-ja convert [options]   Regenerate integration files
  agency-agents-ja list                Print AGENT-LIST.md
  agency-agents-ja path                Print package install path
  agency-agents-ja help                Show this help

Examples:
  npx agency-agents-ja install --tool claude-code
  npx agency-agents-ja install --tool cursor
  npx agency-agents-ja convert --tool openclaw
`);
}

function runScript(scriptName, args) {
  const script = resolve(root, 'scripts', scriptName);
  if (!existsSync(script)) {
    console.error(`Missing script: ${script}`);
    process.exit(1);
  }

  const result = spawnSync('bash', [script, ...args], {
    cwd: process.cwd(),
    stdio: 'inherit',
  });

  if (result.error) {
    if (result.error.code === 'ENOENT') {
      console.error(`bash command が見つからないため、agency-agents-ja の ${scriptName} を実行できません。`);
      if (process.platform === 'win32') {
        console.error(`Windows では次のいずれかの環境で実行してください:`);
        console.error(`  - WSL2 (Ubuntu などの Linux distro)`);
        console.error(`  - Git for Windows に同梱の Git Bash`);
      } else {
        console.error(`bash 4.x 以上を install してください。`);
      }
    } else {
      console.error(result.error.message);
    }
    process.exit(1);
  }
  process.exit(result.status === null ? 1 : result.status);
}

const args = process.argv.slice(2);
if (args[0] === '--help' || args[0] === '-h') {
  help();
  process.exit(0);
}
if (args[0] === '--version' || args[0] === '-v') {
  console.log(pkg.version);
  process.exit(0);
}
const command = args[0] && !args[0].startsWith('-') ? args.shift() : 'install';

switch (command) {
  case 'install':
    runScript('install.sh', args);
    break;
  case 'convert':
    runScript('convert.sh', args);
    break;
  case 'list':
    process.stdout.write(readFileSync(resolve(root, 'AGENT-LIST.md'), 'utf8'));
    break;
  case 'path':
    console.log(root);
    break;
  case 'help':
  case '--help':
  case '-h':
    help();
    break;
  case 'version':
  case '--version':
  case '-v':
    console.log(pkg.version);
    break;
  default:
    console.error(`Unknown command: ${command}`);
    help();
    process.exit(1);
}
