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

project_selection=$(printf '%s' "$project_menu" | LC_ALL=C sort -u | fzf --height 100% --delimiter=$'\t' --with-nth=1 --prompt="Project> " --no-mouse)
[ -z "$project_selection" ] && exit 0

project_name=$(printf '%s' "$project_selection" | cut -f1)
project_dir=$(printf '%s' "$project_selection" | cut -f2)

cd "$project_dir"
git worktree prune >/dev/null 2>&1 || true

local_branches=$(git branch --format='%(refname:short)')
new_branch_label="[create new branch]"
branch_menu="$new_branch_label"$'\t'"new"$'\t'$'\n'
while IFS= read -r local_branch; do
  [ -n "$local_branch" ] || continue
  branch_menu+="[local] ${local_branch}"$'\t'"local"$'\t'"${local_branch}"$'\n'
done <<<"$local_branches"

selection=$(printf '%s' "$branch_menu" | LC_ALL=C sort -u | fzf --height 100% --delimiter=$'\t' --with-nth=1 --prompt="Branch> " --no-mouse)
[ -z "$selection" ] && exit 0

selection_type=$(printf '%s' "$selection" | cut -f2)
selection_ref=$(printf '%s' "$selection" | cut -f3)

if [ "$selection_type" = "new" ]; then
  read -r -p "New branch name: " branch
  [ -z "$branch" ] && exit 0
  if ! git check-ref-format --branch "$branch" >/dev/null 2>&1; then
    echo "Invalid branch name: $branch"
    read -r -p "Press enter to close..."
    exit 1
  fi
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    base_ref=""
    mode="existing"
  else
    base_menu="[current HEAD]"$'\t'"HEAD"$'\n'
    while IFS= read -r local_branch; do
      [ -n "$local_branch" ] || continue
      base_menu+="[local] ${local_branch}"$'\t'"${local_branch}"$'\n'
    done <<<"$local_branches"

    base_selection=$(printf '%s' "$base_menu" | LC_ALL=C sort -u | fzf --height 100% --delimiter=$'\t' --with-nth=1 --prompt="Base branch> " --no-mouse)
    [ -z "$base_selection" ] && exit 0
    base_ref=$(printf '%s' "$base_selection" | cut -f2)
    mode="new"
  fi
else
  branch="$selection_ref"
  base_ref=""
  mode="existing"
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
elif [ "$mode" = "new" ]; then
  printf 'Creating worktree at %s\nLarge/LFS repos can pause here; wait for checkout to finish.\n' "$wt_path"
  if ! git worktree add "$wt_path" -b "$branch" "$base_ref"; then
    printf '\nFailed to create worktree for new branch: %s\n' "$branch"
    read -r -p "Press enter to close..."
    exit 1
  fi
else
  printf 'Creating worktree at %s\nLarge/LFS repos can pause here; wait for checkout to finish.\n' "$wt_path"
  if ! git worktree add "$wt_path" "$branch"; then
    printf '\nFailed to create worktree for existing branch: %s\n' "$branch"
    read -r -p "Press enter to close..."
    exit 1
  fi
fi

sess_name="$(sanitize "$project_name")($worktree_name)"
tmux has-session -t "$sess_name" 2>/dev/null || tmux new-session -d -s "$sess_name" -c "$wt_path"

if [ -z "${TMUX:-}" ]; then
  tmux attach -t "$sess_name"
else
  tmux switch-client -t "$sess_name"
fi
