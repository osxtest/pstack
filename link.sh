#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd -- "$repo_root"

skills=(deslop control-cli control-ui verify-this)

git -C "$HOME/cursor-plugins" pull --ff-only
git -C "$HOME/cursor-plugins" sparse-checkout set pstack cursor-team-kit
for skill in "${skills[@]}"; do
  rm -rf "./skills/$skill"
  ln -s "$HOME/cursor-plugins/cursor-team-kit/skills/$skill" "./skills/$skill"
done
git add -- "${skills[@]/#/skills/}"
git commit -m "upstream: github.com/cursor/plugins cursor-team-kit/skills/{deslop, control-cli, control-ui, verify-this} @ $(git -C "$HOME/cursor-plugins" rev-parse --short HEAD)"
