#!/usr/bin/env bash
# skills.sh — sync one or more Skills from this monorepo out to a target
# project repo's .cursor/skills/ (and, with --claude, .claude/skills/ too).
#
# This is the real distribution mechanism for this skills monorepo: skills
# are authored once here as sibling top-level folders (each its own
# <skill-name>/SKILL.md), then copied out to wherever a team actually wants
# to use them. Nothing here is FIA-specific — FIA's install guide references
# this exact script by name when it explains how a Skill written inside a
# monorepo-of-skills layout reaches a real project.
#
# Usage:
#   ./skills.sh list
#   ./skills.sh sync <skill-name> <target-repo-path> [--claude]
#   ./skills.sh sync-all <target-repo-path> [--claude]

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

list_skills() {
  find "$ROOT_DIR" -maxdepth 2 -mindepth 2 -type f -name 'SKILL.md' \
    | sed "s#$ROOT_DIR/##; s#/SKILL.md##" \
    | sort
}

sync_one() {
  local skill_name="$1"
  local target="$2"
  local also_claude="$3"

  local src="$ROOT_DIR/$skill_name/SKILL.md"
  if [ ! -f "$src" ]; then
    echo "error: no such skill '$skill_name' (run './skills.sh list' to see available skills)" >&2
    return 1
  fi
  if [ ! -d "$target" ]; then
    echo "error: target repo path does not exist: $target" >&2
    return 1
  fi

  local cursor_dest="$target/.cursor/skills/$skill_name"
  mkdir -p "$cursor_dest"
  cp "$src" "$cursor_dest/SKILL.md"
  echo "synced $skill_name -> $cursor_dest/SKILL.md"

  if [ "$also_claude" = "true" ]; then
    local claude_dest="$target/.claude/skills/$skill_name"
    mkdir -p "$claude_dest"
    cp "$src" "$claude_dest/SKILL.md"
    echo "synced $skill_name -> $claude_dest/SKILL.md"
  fi
}

main() {
  local cmd="${1:-}"
  case "$cmd" in
    list)
      list_skills
      ;;
    sync)
      local skill_name="${2:?usage: skills.sh sync <skill-name> <target-repo-path> [--claude]}"
      local target="${3:?usage: skills.sh sync <skill-name> <target-repo-path> [--claude]}"
      local also_claude="false"
      [ "${4:-}" = "--claude" ] && also_claude="true"
      sync_one "$skill_name" "$target" "$also_claude"
      ;;
    sync-all)
      local target="${2:?usage: skills.sh sync-all <target-repo-path> [--claude]}"
      local also_claude="false"
      [ "${3:-}" = "--claude" ] && also_claude="true"
      while IFS= read -r skill_name; do
        sync_one "$skill_name" "$target" "$also_claude"
      done < <(list_skills)
      ;;
    *)
      echo "usage: skills.sh <list|sync|sync-all> [args...]" >&2
      exit 1
      ;;
  esac
}

main "$@"
