# Chief of Staff

A single point of contact for a repo. You talk to this agent. It scopes work, delegates to [pstack](https://github.com/cursor/plugins/tree/main/pstack) workers, tracks status on a board, and reports back.

The pattern is Lauren Tan's (poteto): a coordinator that never writes product code itself. It breaks work down, delegates, and supervises. pstack is a prerequisite. This repo does not vendor it.

## Install the skill

pstack must already be present (Cursor plugin, or Claude Code `pstack@cursor-plugins`).

```bash
git clone https://github.com/Jakkrich/Chief-of-Staff.git
cd Chief-of-Staff
./install.sh          # Cursor if ~/.cursor exists, else Claude Code, else ~/.agents/skills
# ./install.sh cursor
# ./install.sh claude
# ./install.sh agents
```

Windows:

```powershell
git clone https://github.com/Jakkrich/Chief-of-Staff.git
cd Chief-of-Staff
.\install.ps1
# .\install.ps1 -Harness claude
```

Or copy `skills/chief-of-staff/` by hand:

| Harness | Personal skills dir |
|---|---|
| Cursor | `~/.cursor/skills/chief-of-staff/` |
| Claude Code | `~/.claude/skills/chief-of-staff/` |
| Other Agent Skills hosts | `~/.agents/skills/chief-of-staff/` |

## Enable in a repo

The skill does nothing until a project file loads it on the first message. Copy one stub, then add repo notes (verify skill, git host, secrets, branches):

| Harness | Stub |
|---|---|
| Cursor | `templates/cursor-rule.mdc` → `.cursor/rules/chief-of-staff.mdc` |
| Claude Code | `templates/CLAUDE.md` → append into `CLAUDE.md` |
| Other | `templates/AGENTS.md` → append into `AGENTS.md` |

Keep `alwaysApply` (or the equivalent always-loaded pointer) on the **main chat only**. Worker kickoffs that start `Read <path>/worker.md` skip the enable file, so workers do not become coordinators.

Start a chat with `/chief-of-staff` (Claude Code: the same, or `/pstack:poteto-mode` for a single task without the board). On Cursor, Alt+Enter / Option+Enter keeps it as a Custom Mode.

## What it does

- One inbox. Related requests become one ticket. One worker per independent unit.
- Workers are pstack `poteto-agent`s running poteto-mode playbooks. The coordinator reads diffs and evidence; a worker's self-report is not done.
- Status lives in `.context/cos-board.md` in the project. A cold chat starts from `## Latest summary`.
- Irreversible actions (shared-branch push, deploy, deleting data, a message a person outside the run sees) wait for you. Everything else proceeds, then shows up in the brief.

## Layout

```
skills/chief-of-staff/SKILL.md   # coordinator instructions
skills/chief-of-staff/harness.md # Cursor / Claude Code / other tool map
templates/                       # enable stubs + empty board
install.sh / install.ps1
```
