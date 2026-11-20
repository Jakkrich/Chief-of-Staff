#!/usr/bin/env bash
# Copy the Chief of Staff skill into the personal skills dir for this harness.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/skills/chief-of-staff"

dest=""
case "${1:-auto}" in
  cursor) dest="${CURSOR_SKILLS:-$HOME/.cursor/skills/chief-of-staff}" ;;
  claude|claude-code) dest="${CLAUDE_SKILLS:-$HOME/.claude/skills/chief-of-staff}" ;;
  agents) dest="${AGENTS_SKILLS:-$HOME/.agents/skills/chief-of-staff}" ;;
  auto)
    if [[ -d "$HOME/.cursor" ]]; then dest="$HOME/.cursor/skills/chief-of-staff"
    elif [[ -d "$HOME/.claude" ]]; then dest="$HOME/.claude/skills/chief-of-staff"
    else dest="$HOME/.agents/skills/chief-of-staff"
    fi
    ;;
  *)
    echo "usage: $0 [auto|cursor|claude|agents]" >&2
    exit 2
    ;;
esac

mkdir -p "$(dirname "$dest")"
rm -rf "$dest"
cp -R "$SRC" "$dest"
echo "installed $dest"
echo "enable in a repo by copying templates/cursor-rule.mdc, templates/CLAUDE.md, or templates/AGENTS.md"
