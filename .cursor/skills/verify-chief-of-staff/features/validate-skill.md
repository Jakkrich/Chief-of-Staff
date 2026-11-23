# Skill and Template Validation

## Sub-features

- `SKILL.md` YAML frontmatter (`name`, `description`, `disable-model-invocation`)
- Required coordinator sections (`Start of every chat`, `Intake`, `Delegate, don't do`, `Board`, `Waiting on you`, `Brief`, `Away mode`, `Learn`, `Enable in a repo`)
- Byte-level parity between the embedded board template in `SKILL.md` and `templates/cos-board.md`
- Relative markdown links across repo docs and skills
- Non-vendoring check for `pstack`

## How to get to it (user POV)

Run from the repository root after any edit to `skills/chief-of-staff/`, `templates/`, or docs.

## Driving it with Node

```bash
node scripts/validate.mjs
```

Expected exit code `0` and `VALIDATION PASSED` summary.

## Gotchas

- CRLF vs LF differences on Windows are normalized before comparing the embedded board template with `templates/cos-board.md`.
