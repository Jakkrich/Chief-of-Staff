# Harness map

Read this once per chat after you know which tools this session actually has. Map every Cursor name in the skill with the matching row. Never pass a field or value the tool schema rejects.

If `<pstack>/docs/harness/claude-code.md` exists and this session is Claude Code, that file wins over this one.

## Detect

| Session has | Harness |
|---|---|
| `Task` tool and `subagent_type: poteto-agent` | Cursor |
| `Agent` tool and `subagent_type: pstack:poteto-agent`, or paths under `~/.claude/` | Claude Code |
| `invoke_subagent` / `ask_question`, or paths under `~/.gemini/config/` or `~/.gemini/antigravity/` | Antigravity |
| Neither, but a `Task`/`Agent`/`spawn` tool exists | Other. Spawn the closest general worker. First line of the kickoff is still `Read <poteto>/worker.md before anything else.` |

## Resolve pstack

`<pstack>` is the folder that holds `skills/` and `docs/`. `<poteto>` is `<pstack>/skills/poteto-mode`. Search in order and take the first hit that contains `skills/poteto-mode/SKILL.md`:

1. `$PSTACK_ROOT` if set.
2. Newest `~/.cursor/plugins/cache/cursor-public/pstack/*/`.
3. A path under `~/.claude/plugins/` ending in `skills/poteto-mode/SKILL.md`. Walk up to the folder that holds `skills/` and `docs/`.
4. `~/.gemini/config/plugins/pstack/` or `~/.gemini/antigravity/plugins/pstack/`.
5. Newest `~/.cursor/plugins/` or `~/.claude/plugins/` copy whose plugin manifest has the highest `version`.
6. A workspace vendor copy.

If several match at one step, take the highest `version` in `plugin.json` or `.cursor-plugin/plugin.json` or `.claude-plugin/plugin.json`.

## Paths

| Role | Cursor | Claude Code | Antigravity | Other |
|---|---|---|---|---|
| This skill (personal) | `~/.cursor/skills/chief-of-staff/` | `~/.claude/skills/chief-of-staff/` | `~/.gemini/config/skills/chief-of-staff/` (or `~/.gemini/antigravity/skills/chief-of-staff/`) | `~/.agents/skills/chief-of-staff/` or project `.cursor/skills/`, `.claude/skills/`, `.agents/skills/` |
| Project enable file | `.cursor/rules/chief-of-staff.mdc` | `CLAUDE.md` (or `AGENTS.md` if no `CLAUDE.md`) | `AGENTS.md` | `AGENTS.md` |
| Model roles | `~/.cursor/rules/pstack-models.mdc` | `~/.claude/rules/pstack-models.md` | `~/.cursor/rules/pstack-models.mdc` if present, else `poteto-mode` defaults | The pstack model rule the harness already loaded. If none, use `poteto-mode` defaults |
| Slash command | `/chief-of-staff`, `/poteto-mode` | `/chief-of-staff`, `/pstack:poteto-mode` | `/chief-of-staff`, `/poteto-mode` | The harness's skill name. Prefix `pstack:` when that harness prefixes plugin skills |

## Spawn a worker

| Field | Cursor | Claude Code | Antigravity | Other |
|---|---|---|---|---|
| Tool | `Task` | `Agent` | `invoke_subagent` | The session's subagent tool |
| Type | `subagent_type: "poteto-agent"` | `subagent_type: "pstack:poteto-agent"` | `TypeName: "poteto-agent"` | The pstack poteto-agent type if listed, else a general worker with the kickoff below |
| Background | `run_in_background: true` | Omit (default background) | Default async | Background if the schema has it |
| Model | Role line from `pstack-models.mdc` (`auto` / `inherit-parent`: omit `model` and spawn `generalPurpose`) | Map the Cursor slug with `<pstack>/docs/harness/claude-code.md` (`opus`/`sonnet`/`haiku`/`fable` + `effort`). `auto` / `inherit-parent` or non-Claude slugs: omit `model` (and for `auto` / `inherit-parent`, spawn `general-purpose`) | `Model`: `inherit`, `flash`, `flash_lite`, or `pro`. Never pass Cursor slugs. On `auto` / `inherit-parent`, use `Model: "inherit"` and `TypeName: "self"` instead of `poteto-agent` | Pass only values the schema lists |
| Cloud | `environment: "cloud"` | `isolation: "worktree"` | `Workspace: "branch"` or `"share"` | Isolated worktree. Skip dashboard/cloud-agent steps with one line |
| Question tool | `AskQuestion` | `AskUserQuestion` | `ask_question` | Ask in the reply |
| Run another pstack skill | `Read <pstack>/skills/<name>/SKILL.md` and follow it | Same. The `Skill` tool refuses most pstack skills. Tell the operator `/pstack:<name>` | `read_file` `<pstack>/skills/<name>/SKILL.md` and follow it | Same read-and-follow |

Kickoff, every harness:

```
Read <poteto>/worker.md before anything else.
```

Then the goal, the done-check, file pointers, the branch, and the path `<poteto>/SKILL.md`.

## Cursor-only steps

When a step needs Cursor Automations, Bugbot, Cursor cloud agents, or a built-in PR tool the harness lacks: write `Skipped in <harness>: <step>. <reason>.` and continue. Do not stop, ask, or retry. For a PR, use the forge CLI (`gh`, `glab`, `origin`) instead of skipping. In Antigravity, use `schedule` only when the operator asks for a session timer or cron.
