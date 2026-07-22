#!/usr/bin/env bash
set -euo pipefail

project_dirs() {
  local configured="${TMUX_PROJECT_DIRS:-${TMUX_PROJECTS_DIR:-}}"

  if [ -n "$configured" ]; then
    tr ':' '\n' <<<"$configured"
    return
  fi

  if [ -d "$HOME/raft-tech" ]; then
    printf '%s\n' "$HOME/raft-tech"
  elif [ -d "$HOME/Projects" ]; then
    printf '%s\n' "$HOME/Projects"
  else
    printf '%s\n' "$HOME"
  fi
}

sanitize() {
  printf '%s' "$1" | tr '.:/ ' '----'
}

project_menu=""
while IFS= read -r root; do
  root="${root/#\~/$HOME}"
  [ -d "$root" ] || continue
  for dir in "$root"/*/; do
    [ -d "$dir" ] || continue
    { [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; } || continue
    project_menu+="$(basename "$dir")"$'\t'"${dir%/}"$'\n'
  done
done < <(project_dirs)

[ -z "$project_menu" ] && exit 0

project_selection=$(printf '%s' "$project_menu" | LC_ALL=C sort -u | fzf --height 100% --delimiter=$'\t' --with-nth=1 --prompt="Project> ")
[ -z "$project_selection" ] && exit 0

project_name=$(printf '%s' "$project_selection" | cut -f1)
project_dir=$(printf '%s' "$project_selection" | cut -f2)

cd "$project_dir"
git worktree prune >/dev/null 2>&1 || true

branches=$(git branch --format='%(refname:short)')
selection=$(printf '%s\n[new branch]\n' "$branches" | fzf --height 100% --prompt="Branch> ")
[ -z "$selection" ] && exit 0

if [ "$selection" = "[new branch]" ]; then
  read -r -p "New branch name: " branch
  [ -z "$branch" ] && exit 0
  is_new=true
else
  branch="$selection"
  is_new=false
fi

worktree_name=$(sanitize "$branch")
wt_root="$project_dir/.worktrees"
wt_path="$wt_root/$worktree_name"
mkdir -p "$wt_root"

if [ -f .gitignore ] && ! grep -qxF '.worktrees/' .gitignore 2>/dev/null; then
  printf '\n.worktrees/\n' >> .gitignore
elif [ ! -f .gitignore ]; then
  printf '.worktrees/\n' > .gitignore
fi

existing_path=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '
  /^worktree / { path=$0; sub(/^worktree /, "", path) }
  $0 == "branch " b { print path }
')

if [ -n "$existing_path" ]; then
  wt_path="$existing_path"
elif [ -d "$wt_path" ]; then
  echo "Directory exists but is not a registered worktree: $wt_path"
  read -r -p "Press enter to close..."
  exit 1
elif [ "$is_new" = true ]; then
  git worktree add "$wt_path" -b "$branch"
else
  git worktree add "$wt_path" "$branch"
fi

sess_name="$(sanitize "$project_name")($worktree_name)"
tmux has-session -t "$sess_name" 2>/dev/null || tmux new-session -d -s "$sess_name" -c "$wt_path"

if [ -z "${TMUX:-}" ]; then
  tmux attach -t "$sess_name"
else
  tmux switch-client -t "$sess_name"
fi
