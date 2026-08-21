#!/usr/bin/env bash
# Link this repo's rules and skills into the agent home directories.
# Safe to run repeatedly: local machines and cloud agent install scripts.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
  local target=$1 link_path=$2

  if [[ -e $link_path && ! -L $link_path ]]; then
    echo "refusing to replace existing non-symlink: $link_path" >&2
    return 1
  fi

  mkdir -p "$(dirname "$link_path")"
  ln -sfn "$target" "$link_path"
  echo "linked $link_path -> $target"
}

link "$repo_root/agents" "$HOME/.cursor/rules"
link "$repo_root/skills" "$HOME/.cursor/skills"

if [[ ${1-} == --claude ]]; then
  link "$repo_root/agents/coding-philosophy.mdc" "$HOME/.claude/CLAUDE.md"
  link "$repo_root/skills" "$HOME/.claude/skills"
fi
