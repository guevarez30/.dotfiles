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

# Menu lines: label<TAB>repo<TAB>worktree<TAB>session
menu=""

while IFS= read -r root; do
  root="${root/#\~/$HOME}"
  [ -d "$root" ] || continue

  for repo in "$root"/*/; do
    [ -d "$repo" ] || continue
    { [ -d "$repo/.git" ] || [ -f "$repo/.git" ]; } || continue

    repo="${repo%/}"
    project_name=$(basename "$repo")
    git -C "$repo" worktree prune >/dev/null 2>&1 || true

    while IFS= read -r wt_path; do
      [ -n "$wt_path" ] || continue
      [ "$wt_path" = "$repo" ] && continue
      [ -d "$wt_path" ] || continue

      branch=$(git -C "$wt_path" branch --show-current 2>/dev/null || true)
      [ -n "$branch" ] || branch=$(basename "$wt_path")
      wt_name=$(basename "$wt_path")
      sess_name="$(sanitize "$project_name")($(sanitize "$wt_name"))"

      menu+="[delete] ${project_name} (${branch})"$'\t'"${repo}"$'\t'"${wt_path}"$'\t'"${sess_name}"$'\n'
    done < <(git -C "$repo" worktree list --porcelain 2>/dev/null | awk '/^worktree / { sub(/^worktree /, ""); print }')
  done
done < <(project_dirs)

[ -z "$menu" ] && exit 0

selection=$(printf '%s' "$menu" | LC_ALL=C sort -u | fzf --height 100% --delimiter=$'\t' --with-nth=1 --prompt="Delete worktree> ")
[ -z "$selection" ] && exit 0

label=$(printf '%s' "$selection" | cut -f1)
repo=$(printf '%s' "$selection" | cut -f2)
wt_path=$(printf '%s' "$selection" | cut -f3)
sess_name=$(printf '%s' "$selection" | cut -f4)

printf 'Delete %s?\n\n%s\n\n' "$label" "$wt_path"
read -r -p "Type delete to confirm: " confirm
[ "$confirm" = "delete" ] || exit 0

if ! git -C "$repo" worktree remove "$wt_path"; then
  printf '\nWorktree has uncommitted changes or remove failed.\n'
  read -r -p "Force remove? Type force: " force
  [ "$force" = "force" ] || exit 1
  git -C "$repo" worktree remove --force "$wt_path"
fi

if tmux has-session -t "$sess_name" 2>/dev/null; then
  tmux kill-session -t "$sess_name"
fi

git -C "$repo" worktree prune >/dev/null 2>&1 || true
printf 'Removed %s\n' "$wt_path"
read -r -p "Press enter to close..."
