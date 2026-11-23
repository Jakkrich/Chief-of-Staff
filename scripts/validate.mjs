#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const failures = [];
const checks = [];

function fail(msg) {
  failures.push(msg);
}

function pass(msg) {
  checks.push(msg);
}

function read(relPath) {
  return fs.readFileSync(path.join(root, relPath), 'utf8').replace(/\r\n/g, '\n');
}

function exists(relPath) {
  return fs.existsSync(path.join(root, relPath));
}

function parseFrontmatter(content) {
  const match = content.match(/^---\n([\s\S]*?)\n---\n/);
  if (!match) return null;
  const map = {};
  for (const line of match[1].split('\n')) {
    const idx = line.indexOf(':');
    if (idx === -1) continue;
    const key = line.slice(0, idx).trim();
    const val = line.slice(idx + 1).trim();
    if (key) map[key] = val;
  }
  return map;
}

// 1. Validate core skill frontmatter, sections, and board template parity
const skillRel = 'skills/chief-of-staff/SKILL.md';
if (!exists(skillRel)) {
  fail(`Missing ${skillRel}`);
} else {
  const skill = read(skillRel);
  const fm = parseFrontmatter(skill);
  if (!fm) {
    fail(`${skillRel}: missing YAML frontmatter`);
  } else {
    if (fm.name !== 'chief-of-staff') fail(`${skillRel}: frontmatter name must be "chief-of-staff"`);
    if (!fm.description || fm.description.length < 20) fail(`${skillRel}: frontmatter description missing or too short`);
    if (fm['disable-model-invocation'] !== 'true') fail(`${skillRel}: disable-model-invocation must be true`);
  }

  const requiredHeadings = [
    '## Start of every chat',
    '## Intake',
    "## Delegate, don't do",
    '## Board',
    '## Waiting on you',
    '## Brief',
    '## Away mode',
    '## Learn',
    '## Enable in a repo',
  ];
  for (const heading of requiredHeadings) {
    if (!skill.includes(heading)) fail(`${skillRel}: missing required heading "${heading}"`);
  }

  const templateRel = 'templates/cos-board.md';
  if (!exists(templateRel)) {
    fail(`Missing ${templateRel}`);
  } else {
    const tpl = read(templateRel).trim();
    const blockMatch = skill.match(/Template, with today's date and the repo folder name:\n\n```markdown\n([\s\S]*?)\n```/);
    if (!blockMatch) {
      fail(`${skillRel}: missing embedded board template block`);
    } else if (blockMatch[1].trim() !== tpl) {
      fail(`${skillRel}: embedded board template drifted from ${templateRel}`);
    } else {
      pass('Board template in SKILL.md matches templates/cos-board.md');
    }
  }
  pass('Validated SKILL.md frontmatter and required sections');
}

// 2. Validate harness.md coverage
const harnessRel = 'skills/chief-of-staff/harness.md';
if (!exists(harnessRel)) {
  fail(`Missing ${harnessRel}`);
} else {
  const harness = read(harnessRel);
  for (const term of [
    'Cursor',
    'Claude Code',
    'Antigravity',
    'Other',
    '~/.gemini/config/plugins/pstack/',
    'auto',
    'inherit-parent',
    'Skipped in',
  ]) {
    if (!harness.includes(term)) fail(`${harnessRel}: missing "${term}"`);
  }
  pass('Validated harness.md multi-harness coverage');
}

// 3. Validate verify-chief-of-staff skill frontmatter
const verifySkillRel = '.cursor/skills/verify-chief-of-staff/SKILL.md';
if (!exists(verifySkillRel)) {
  fail(`Missing ${verifySkillRel}`);
} else {
  const vf = parseFrontmatter(read(verifySkillRel));
  if (!vf || vf.name !== 'verify-chief-of-staff' || !vf.description) {
    fail(`${verifySkillRel}: invalid or missing frontmatter`);
  } else {
    pass('Validated verify-chief-of-staff frontmatter');
  }
}

// 4. Validate markdown relative links across repo docs & skills
const mdFiles = [
  'README.md',
  'AGENTS.md',
  'skills/chief-of-staff/SKILL.md',
  'skills/chief-of-staff/harness.md',
  'examples/cos-board-example.md',
  '.cursor/skills/verify-chief-of-staff/SKILL.md',
  '.cursor/skills/verify-chief-of-staff/features/README.md',
  '.cursor/skills/verify-chief-of-staff/features/validate-skill.md',
  '.cursor/skills/verify-chief-of-staff/features/installer-smoke.md',
  '.cursor/skills/verify-chief-of-staff/features/harness-parity.md',
].filter(exists);

const linkPattern = /\[[^\]]+\]\(([^)]+)\)/g;
for (const rel of mdFiles) {
  const content = read(rel);
  const dir = path.dirname(path.join(root, rel));
  for (const m of content.matchAll(linkPattern)) {
    const target = m[1].trim();
    if (!target || /^(https?:|mailto:|#)/.test(target)) continue;
    const cleanTarget = target.split('#')[0];
    if (!cleanTarget) continue;
    const resolved = path.resolve(dir, cleanTarget);
    if (!fs.existsSync(resolved)) {
      fail(`${rel}: broken relative link "${target}"`);
    }
  }
}
pass(`Checked relative markdown links across ${mdFiles.length} files`);

// 5. Ensure pstack is never vendored in this repo
for (const forbidden of ['skills/poteto-mode', 'skills/setup-pstack', '.cursor-plugin', '.claude-plugin']) {
  if (exists(forbidden)) fail(`Repo must not vendor pstack artifact: ${forbidden}`);
}
pass('Confirmed pstack is not vendored');

// 6. Ensure required templates, installers, and examples exist
for (const req of [
  'templates/AGENTS.md',
  'templates/CLAUDE.md',
  'templates/cos-board.md',
  'templates/cursor-rule.mdc',
  'examples/cos-board-example.md',
  '.github/workflows/validate.yml',
  'install.ps1',
  'install.sh',
]) {
  if (!exists(req)) fail(`Missing required file: ${req}`);
}
pass('Verified required templates, examples, CI, and installers');

if (failures.length > 0) {
  console.error('VALIDATION FAILED:');
  for (const f of failures) console.error(`  - ${f}`);
  process.exit(1);
}

console.log(`VALIDATION PASSED (${checks.length} checks):`);
for (const c of checks) console.log(`  - ${c}`);
