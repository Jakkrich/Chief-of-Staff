# Harness and pstack Parity

## Sub-features

- Harness detection for Cursor, Claude Code, Antigravity, and generic Agent Skills hosts
- `Resolve pstack` search order covering `$PSTACK_ROOT`, Cursor, Claude Code, Antigravity (`~/.gemini/config/plugins/pstack`), and workspace vendor copies
- Model rule handling (`auto` and `inherit-parent` omit `model` and avoid `poteto-agent`)

## How to get to it (user POV)

Compare `skills/chief-of-staff/harness.md` against the installed `pstack` plugin's `docs/harness/claude-code.md` and `skills/poteto-mode/SKILL.md`.

## Driving it with Node and diff inspection

```bash
node scripts/validate.mjs
```

And read `<pstack>/docs/harness/claude-code.md` alongside `skills/chief-of-staff/harness.md` whenever `pstack` updates.

## Gotchas

- Updating `harness.md` without updating `README.md` or `templates/` can leave stale setup instructions for new users.
