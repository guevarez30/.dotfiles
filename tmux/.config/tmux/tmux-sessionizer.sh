#!/usr/bin/env bash
# Deprecated: prefer tmux built-in session tree (`prefix-s`) for sessions.
# Kept as an escape hatch for fuzzy project/session creation.
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

session_name() {
  printf '%s' "$1" | tr '.:/ ' '----'
}

# Menu lines: label<TAB>session<TAB>path<TAB>type
menu=""
switch_only="${TMUX_SESSIONIZER_SWITCH_ONLY:-false}"

if tmux ls >/dev/null 2>&1; then
  while IFS= read -r sess; do
    menu+="[switch] ${sess}"$'\t'"${sess}"$'\t'"${sess}"$'\t'"switch"$'\n'
  done < <(tmux list-sessions -F '#{session_name}')
fi

while IFS= read -r root; do
  root="${root/#\~/$HOME}"
  [ -d "$root" ] || continue

  for dir in "$root"/*/; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    sess=$(session_name "$name")

    if [ "$switch_only" != true ] && ! tmux has-session -t "$sess" 2>/dev/null; then
      menu+="[new] ${name}"$'\t'"${sess}"$'\t'"${dir%/}"$'\t'"new"$'\n'
    fi

    { [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; } || continue
    (cd "$dir" && git worktree prune >/dev/null 2>&1) || true

    while IFS= read -r wt_path; do
      [ -n "$wt_path" ] || continue
      [ "$wt_path" = "${dir%/}" ] && continue
      [ -d "$wt_path" ] || continue

      branch=$(git -C "$wt_path" branch --show-current 2>/dev/null || true)
      [ -n "$branch" ] || branch=$(basename "$wt_path")
      wt_label=$(basename "$wt_path")
      wt_sess="$(session_name "$name")($(session_name "$wt_label"))"

      if tmux has-session -t "$wt_sess" 2>/dev/null; then
        label="[switch] ${name} (${branch})"
        type="switch"
      elif [ "$switch_only" != true ]; then
        label="[new] ${name} (${branch}) [worktree]"
        type="new"
      else
        continue
      fi

      menu+="${label}"$'\t'"${wt_sess}"$'\t'"${wt_path}"$'\t'"${type}"$'\n'
    done < <(git -C "$dir" worktree list --porcelain 2>/dev/null | awk '/^worktree / { sub(/^worktree /, ""); print }')
  done
done < <(project_dirs)

[ -z "$menu" ] && exit 0

selection=$(printf '%s' "$menu" | LC_ALL=C sort -u -t$'\t' -k2,2 | fzf --height 100% --delimiter=$'\t' --with-nth=1)
[ -z "$selection" ] && exit 0

sess=$(printf '%s' "$selection" | cut -f2)
path=$(printf '%s' "$selection" | cut -f3)
type=$(printf '%s' "$selection" | cut -f4)

if [ "$type" = "switch" ]; then
  if [ -z "${TMUX:-}" ]; then
    tmux attach -t "$sess"
  else
    tmux switch-client -t "$sess"
  fi
elif [ -z "${TMUX:-}" ]; then
  tmux new-session -s "$sess" -c "$path"
else
  tmux new-session -d -s "$sess" -c "$path"
  tmux switch-client -t "$sess"
fi
