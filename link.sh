#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"

mkdir -p "$SKILLS_DIR"

for dir in "$REPO_DIR"/*/; do
  name="$(basename "$dir")"
  [[ "$name" == "learned" ]] && continue

  target="$SKILLS_DIR/$name"

  if [[ -L "$target" ]]; then
    echo "skip: $name (already linked)"
  elif [[ -e "$target" ]]; then
    echo "skip: $name (non-symlink already exists in skills/)"
  else
    ln -s "$dir" "$target"
    echo "linked: $name -> $dir"
  fi
done
