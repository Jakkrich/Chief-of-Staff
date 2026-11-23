# Chief of Staff

A single point of contact for a repo. You talk to this agent. It scopes work, delegates to [pstack](https://github.com/cursor/plugins/tree/main/pstack) workers, tracks status on a board, and reports back.

The pattern is Lauren Tan's (poteto): a coordinator that never writes product code itself. It breaks work down, delegates, and supervises. pstack is a prerequisite. This repo does not vendor it.

## Install the skill

pstack must already be present (Cursor plugin, Claude Code `pstack@cursor-plugins`, or Antigravity `~/.gemini/config/plugins/pstack`).

```bash
git clone https://github.com/Jakkrich/Chief-of-Staff.git
cd Chief-of-Staff
./install.sh                  # Auto-detect Cursor, Claude Code, Antigravity, or ~/.agents/skills
# ./install.sh cursor
# ./install.sh claude
# ./install.sh antigravity
# ./install.sh all --link     # Symlink repo so edits stay live
# ./install.sh all --dry-run
```

Windows:

```powershell
git clone https://github.com/Jakkrich/Chief-of-Staff.git
cd Chief-of-Staff
.\install.ps1
# .\install.ps1 -Harness antigravity
# .\install.ps1 -Harness all -Link
# .\install.ps1 -Harness all -WhatIf
```

Or copy `skills/chief-of-staff/` by hand:

| Harness | Personal skills dir |
|---|---|
| Cursor | `~/.cursor/skills/chief-of-staff/` |
| Claude Code | `~/.claude/skills/chief-of-staff/` |
| Antigravity | `~/.gemini/config/skills/chief-of-staff/` |
| Other Agent Skills hosts | `~/.agents/skills/chief-of-staff/` |

## Enable in a repo

The skill does nothing until a project file loads it on the first message. Copy one stub, then add repo notes (verify skill, git host, secrets, branches):

| Harness | Stub |
|---|---|
| Cursor | `templates/cursor-rule.mdc` -> `.cursor/rules/chief-of-staff.mdc` |
| Claude Code | `templates/CLAUDE.md` -> append into `CLAUDE.md` |
| Antigravity / Other | `templates/AGENTS.md` -> append into `AGENTS.md` |

Keep `alwaysApply` (or the equivalent always-loaded pointer) on the **main chat only**. Worker kickoffs that start `Read <path>/worker.md` skip the enable file, so workers do not become coordinators.

Start a chat with `/chief-of-staff` (Claude Code: the same, or `/pstack:poteto-mode` for a single task without the board). On Cursor, Alt+Enter / Option+Enter keeps it as a Custom Mode.

## What it does

- One inbox, one coordinator. Supports `"new task"` mid-chat to re-match playbooks cleanly, and routes through pstack's full playbook/skill ladder (`/how`, `/why`, `/teach`, `/recall`, `/architect`, `Prototype`, `/arena` vs `/swarm`, `/tdd`, `/interrogate`, `/blast-radius`, `/benchmark-checklist`, `Opening a PR` -> `Babysit` -> `Shipping`).
- Workers are `poteto-agent`s honoring `pstack-models` (`auto` and `inherit-parent` omit `model` and spawn `generalPurpose` / `general-purpose` / `self`). Cleanup runs `/deslop`, `/no-comments`, and `/unslop`. The coordinator reads diffs and evidence; a worker's self-report is not done.
- Status lives in `.context/cos-board.md` in the project. A cold chat starts from `## Latest summary`. See [examples/cos-board-example.md](examples/cos-board-example.md) for a multi-worktree example.
- Briefs follow `/ketchup` order with `show-me-your-work` `Attention` trails when unattended work ran. Away mode enforces checkable predicates, `Autopilot-full` vs `Autopilot-stack`, and `Pause safely`.
- Irreversible actions (shared-branch push, deploy, deleting data, a message a person outside the run sees, merging without `Autopilot-full` grant) wait for you. Everything else proceeds, then shows up in the brief.

## Validate

```bash
node scripts/validate.mjs
```

## Layout

```text
skills/chief-of-staff/SKILL.md     # coordinator instructions
skills/chief-of-staff/harness.md   # Cursor / Claude Code / Antigravity / other tool map
templates/                         # enable stubs + empty board
examples/                          # worked board example
scripts/validate.mjs               # frontmatter, link, and board parity checks
.cursor/skills/verify-chief-of-staff/ # repo verification skill
install.sh / install.ps1
```
