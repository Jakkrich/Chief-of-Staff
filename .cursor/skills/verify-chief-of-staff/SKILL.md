---
name: verify-chief-of-staff
description: Verify the Chief-of-Staff skill repository end to end: validate skill frontmatter, relative links, board template parity, and isolated installer runs across harnesses without mutating the operator's real home directory.
disable-model-invocation: true
---

# Verify Chief of Staff

Verify changes to `Chief-of-Staff` against the real repository files and isolated temporary `$HOME` directories.

## Launch

No long-running server is required. Ensure `node` (`>= 18`), `git`, and `powershell` or `bash` are available in the repo root.

## Doctor

Run a read-only check before exercising features:

```bash
node --version
git status -sb
node scripts/validate.mjs
```

If `node scripts/validate.mjs` fails, fix the reported frontmatter, link, or template drift first.

## Drive

Follow the feature map in [features/README.md](features/README.md):

1. Validate skill structure, links, and board parity with `node scripts/validate.mjs`.
2. Smoke-test `install.ps1` (Windows) and `install.sh` (Unix/WSL/Git Bash) against a freshly created temporary `$HOME` / `$USERPROFILE` directory using both dry-run and real copy/link modes.
3. Audit `skills/chief-of-staff/harness.md` against local `pstack/docs/harness/claude-code.md` (when `pstack` is installed) so model mapping and `auto`/`inherit-parent` rules stay aligned.

## Evidence

Capture exact command outputs into `.context/verify-evidence.txt` (gitignored under `.context/`):
- Output of `node scripts/validate.mjs` (`VALIDATION PASSED`)
- Temp-directory tree or SHA-256 verification showing installed `SKILL.md` and `harness.md` match `skills/chief-of-staff/`
- Dry-run output confirming no files were written during `--dry-run` / `-WhatIf`

## Cleanup

Delete only temporary `$HOME` directories created in `$env:TEMP` / `/tmp`. Leave `.context/verify-evidence.txt` intact so the proof survives cleanup.

## Helpers

- `scripts/validate.mjs` — zero-dependency Node validator for frontmatter, links, templates, and non-vendoring rules.
