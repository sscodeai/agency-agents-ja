#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const YAML = require('yaml');

const root = process.cwd();
const workflowDir = path.join(root, 'workflows');
const examplesDir = path.join(root, 'examples');

let errors = 0;

function fail(file, message) {
  console.error(`${file}: ${message}`);
  errors += 1;
}

function read(file) {
  return fs.readFileSync(file, 'utf8');
}

function normalizeText(text) {
  return text.trim().replace(/\r\n/g, '\n');
}

function parseYaml(relativeFile, text) {
  try {
    return YAML.parse(text);
  } catch (error) {
    fail(relativeFile, `invalid YAML: ${error.message}`);
    return null;
  }
}

function extractFirstYamlBlock(text) {
  const match = text.match(/```ya?ml\n([\s\S]*?)\n```/);
  return match && match[1];
}

function assertString(file, workflow, key) {
  if (typeof workflow[key] !== 'string' || workflow[key].trim() === '') {
    fail(file, `missing or invalid ${key} field`);
    return '';
  }
  return workflow[key].trim();
}

function inputNames(workflow) {
  if (workflow.inputs === undefined) return new Set();
  if (!Array.isArray(workflow.inputs)) return new Set();
  return new Set(
    workflow.inputs
      .filter((input) => input && typeof input.name === 'string')
      .map((input) => input.name),
  );
}

function placeholders(value) {
  if (typeof value !== 'string') return [];
  return [...value.matchAll(/\{\{\s*([A-Za-z0-9_-]+)\s*\}\}/g)].map((match) => match[1]);
}

function validateWorkflowText(relativeFile, text) {
  const workflow = parseYaml(relativeFile, text);
  if (!workflow || typeof workflow !== 'object' || Array.isArray(workflow)) {
    fail(relativeFile, 'workflow YAML must be a mapping');
    return { name: '', steps: [] };
  }

  const name = assertString(relativeFile, workflow, 'name');
  assertString(relativeFile, workflow, 'description');

  if (workflow.agents_dir !== '.') {
    fail(relativeFile, 'agents_dir must be "."');
  }

  if (workflow.inputs !== undefined && !Array.isArray(workflow.inputs)) {
    fail(relativeFile, 'inputs must be a list when present');
  }
  if (Array.isArray(workflow.inputs)) {
    const seenInputs = new Set();
    for (const input of workflow.inputs) {
      if (!input || typeof input !== 'object' || Array.isArray(input)) {
        fail(relativeFile, 'input entries must be mappings');
        continue;
      }
      if (typeof input.name !== 'string' || input.name.trim() === '') {
        fail(relativeFile, 'input entry is missing name');
        continue;
      }
      if (seenInputs.has(input.name)) {
        fail(relativeFile, `duplicate input name: ${input.name}`);
      }
      seenInputs.add(input.name);
    }
  }

  const steps = workflow.steps;
  if (!Array.isArray(steps) || steps.length === 0) {
    fail(relativeFile, 'steps must contain at least one step');
    return { name, steps: [] };
  }

  const stepIds = new Set();
  const outputToStepId = new Map();
  for (const [index, step] of steps.entries()) {
    if (!step || typeof step !== 'object' || Array.isArray(step)) {
      fail(relativeFile, `step ${index + 1} must be a mapping`);
      continue;
    }
    if (typeof step.id !== 'string' || step.id.trim() === '') {
      fail(relativeFile, `step ${index + 1} is missing id`);
      continue;
    }
    if (stepIds.has(step.id)) {
      fail(relativeFile, `duplicate step id: ${step.id}`);
    }
    stepIds.add(step.id);

    if (typeof step.output === 'string' && step.output.trim()) {
      if (outputToStepId.has(step.output)) {
        fail(relativeFile, `duplicate step output: ${step.output}`);
      }
      outputToStepId.set(step.output, step.id);
    }
  }

  const seenStepIds = new Set();
  const knownInputs = inputNames(workflow);
  const graph = new Map();

  for (const step of steps) {
    if (!step || typeof step !== 'object' || Array.isArray(step)) continue;
    const id = typeof step.id === 'string' ? step.id : '';
    if (!id) continue;

    if (typeof step.role !== 'string' || step.role.trim() === '') {
      fail(relativeFile, `step ${id} is missing role`);
    } else {
      const agentFile = path.join(root, `${step.role}.md`);
      if (!fs.existsSync(agentFile)) {
        fail(relativeFile, `step ${id} references missing agent: ${step.role}.md`);
      }
    }

    if (typeof step.task !== 'string' || step.task.trim() === '') {
      fail(relativeFile, `step ${id} is missing task`);
    }

    const dependsOn = step.depends_on === undefined ? [] : step.depends_on;
    if (!Array.isArray(dependsOn)) {
      fail(relativeFile, `step ${id} depends_on must be a list`);
      graph.set(id, []);
    } else {
      graph.set(id, dependsOn);
      for (const dependency of dependsOn) {
        if (typeof dependency !== 'string' || dependency.trim() === '') {
          fail(relativeFile, `step ${id} has invalid depends_on entry`);
          continue;
        }
        if (!stepIds.has(dependency)) {
          fail(relativeFile, `step ${id} depends on missing step: ${dependency}`);
        }
        if (!seenStepIds.has(dependency)) {
          fail(relativeFile, `step ${id} depends on non-prior step: ${dependency}`);
        }
      }
    }

    const availablePlaceholders = new Set(knownInputs);
    for (const [output, producerId] of outputToStepId.entries()) {
      if (seenStepIds.has(producerId)) availablePlaceholders.add(output);
    }
    for (const placeholder of placeholders(step.task)) {
      if (!availablePlaceholders.has(placeholder)) {
        fail(relativeFile, `step ${id} references unavailable placeholder: ${placeholder}`);
      }
    }

    seenStepIds.add(id);
  }

  const visiting = new Set();
  const visited = new Set();
  function visit(id, trail = []) {
    if (visiting.has(id)) {
      fail(relativeFile, `steps contain a dependency cycle: ${[...trail, id].join(' -> ')}`);
      return;
    }
    if (visited.has(id)) return;
    visiting.add(id);
    for (const dependency of graph.get(id) || []) {
      if (stepIds.has(dependency)) visit(dependency, [...trail, id]);
    }
    visiting.delete(id);
    visited.add(id);
  }
  for (const id of stepIds) visit(id);

  return { name, steps };
}

if (!fs.existsSync(workflowDir)) {
  fail('workflows', 'directory is missing');
} else {
  const files = fs
    .readdirSync(workflowDir)
    .filter((file) => file.endsWith('.yaml') || file.endsWith('.yml'))
    .sort();

  if (files.length === 0) {
    fail('workflows', 'no workflow YAML files found');
  }

  for (const filename of files) {
    const relativeFile = path.join('workflows', filename);
    validateWorkflowText(relativeFile, read(path.join(workflowDir, filename)));
  }
}

if (fs.existsSync(examplesDir)) {
  const workflowsByName = new Map();
  if (fs.existsSync(workflowDir)) {
    for (const filename of fs.readdirSync(workflowDir)) {
      if (!filename.endsWith('.yaml') && !filename.endsWith('.yml')) continue;
      const relativeFile = path.join('workflows', filename);
      const text = read(path.join(workflowDir, filename));
      const workflow = parseYaml(relativeFile, text);
      if (workflow && typeof workflow.name === 'string') {
        workflowsByName.set(workflow.name, normalizeText(text));
      }
    }
  }

  const exampleFiles = fs
    .readdirSync(examplesDir)
    .filter((file) => file.startsWith('workflow-') && file.endsWith('.md'))
    .sort();

  for (const filename of exampleFiles) {
    const relativeFile = path.join('examples', filename);
    const text = read(path.join(examplesDir, filename));
    const yaml = extractFirstYamlBlock(text);

    if (!yaml) {
      fail(relativeFile, 'missing YAML code block');
      continue;
    }

    const { name } = validateWorkflowText(relativeFile, yaml);
    if (name && !workflowsByName.has(name)) {
      fail(relativeFile, `example references missing workflow: ${name}`);
    } else if (name && normalizeText(yaml) !== workflowsByName.get(name)) {
      fail(relativeFile, `example YAML is out of sync with workflow: ${name}`);
    }
  }
}

if (errors > 0) {
  process.exit(1);
}

console.log('All workflow files are valid.');
