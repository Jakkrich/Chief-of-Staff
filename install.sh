#!/usr/bin/env bash
# Copy or link the Chief of Staff skill into personal skills dirs for supported harnesses.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/skills/chief-of-staff"

harness="auto"
link_mode=0
dry_run=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --link|-l) link_mode=1 ;;
    --dry-run|-n) dry_run=1 ;;
    --help|-h)
      echo "usage: $0 [auto|cursor|claude|antigravity|agents|all] [--link] [--dry-run]"
      exit 0
      ;;
    cursor|claude|claude-code|antigravity|agents|all|auto)
      harness="$1"
      ;;
    *)
      echo "usage: $0 [auto|cursor|claude|antigravity|agents|all] [--link] [--dry-run]" >&2
      exit 2
      ;;
  esac
  shift
done

dest_for() {
  case "$1" in
    cursor) echo "${CURSOR_SKILLS:-$HOME/.cursor/skills/chief-of-staff}" ;;
    claude|claude-code) echo "${CLAUDE_SKILLS:-$HOME/.claude/skills/chief-of-staff}" ;;
    antigravity) echo "${ANTIGRAVITY_SKILLS:-$HOME/.gemini/config/skills/chief-of-staff}" ;;
    agents) echo "${AGENTS_SKILLS:-$HOME/.agents/skills/chief-of-staff}" ;;
  esac
}

targets=()
case "$harness" in
  all)
    targets=(cursor claude antigravity agents)
    ;;
  auto)
    if [[ -d "$HOME/.cursor" ]]; then targets=(cursor)
    elif [[ -d "$HOME/.claude" ]]; then targets=(claude)
    elif [[ -d "$HOME/.gemini/antigravity" || -d "$HOME/.gemini/config" ]]; then targets=(antigravity)
    else targets=(agents)
    fi
    ;;
  *)
    targets=("$harness")
    ;;
esac

for t in "${targets[@]}"; do
  dest="$(dest_for "$t")"
  if [[ "$dry_run" -eq 1 ]]; then
    if [[ "$link_mode" -eq 1 ]]; then
      echo "[dry-run] link $dest -> $SRC"
    else
      echo "[dry-run] copy $SRC -> $dest"
    fi
    continue
  fi

  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  if [[ "$link_mode" -eq 1 ]]; then
    ln -sfn "$SRC" "$dest"
    echo "linked $dest -> $SRC"
  else
    cp -R "$SRC" "$dest"
    echo "installed $dest"
  fi
done

echo "enable in a repo by copying templates/cursor-rule.mdc, templates/CLAUDE.md, or templates/AGENTS.md"
