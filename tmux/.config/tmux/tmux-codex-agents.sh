#!/usr/bin/env bash
set -euo pipefail

pane_text() {
  tmux capture-pane -p -t "$1" -S -300 2>/dev/null || true
}

pane_status_text() {
  tmux capture-pane -p -t "$1" -S -8 2>/dev/null || true
}

is_codex_pane() {
  local pane_id="$1"
  local command="$2"
  local start_command="$3"
  local title="$4"
  local text

  case "${command} ${start_command} ${title}" in
    *codex*|*Codex*) return 0 ;;
  esac

  case "$command" in
    codex|node) ;;
    *) return 1 ;;
  esac

  text=$(pane_text "$pane_id")
  grep -Eiq '(^|[^[:alnum:]])codex([^[:alnum:]]|$)|OpenAI Codex|GPT-5' <<<"$text"
}

pane_status() {
  local pane_id="$1"
  local pane_dead="$2"
  local text

  [ "$pane_dead" = "1" ] && {
    printf '\033[31m●\033[0m'
    return
  }

  text=$(pane_status_text "$pane_id")

  if grep -Eiq 'esc to interrupt|ctrl-c to interrupt|interrupt current' <<<"$text"; then
    printf '\033[34m●\033[0m'
  elif grep -Eiq 'would you like to run|press enter to confirm or esc to cancel|yes, proceed|tell codex what to do differently' <<<"$text"; then
    printf '\033[33m●\033[0m'
  else
    printf '\033[32m●\033[0m'
  fi
}

short_path() {
  local path="$1"
  case "$path" in
    "$HOME") printf '~' ;;
    "$HOME"/*) printf '~/%s' "${path#"$HOME"/}" ;;
    *) printf '%s' "$path" ;;
  esac
}

session_name_for_thread() {
  local thread_id="$1"
  local index_file="$HOME/.codex/session_index.jsonl"

  [ -f "$index_file" ] || return 1

  awk -v id="$thread_id" '
    $0 ~ "\"id\":\"" id "\"" {
      line = $0
      sub(/^.*"thread_name":"/, "", line)
      sub(/","updated_at".*$/, "", line)
      name = line
    }
    END {
      if (name != "") {
        print name
      }
    }
  ' "$index_file"
}

codex_thread_name() {
  local pane_id="$1"
  local text thread_id name

  text=$(pane_text "$pane_id")

  while IFS= read -r thread_id; do
    [ -n "$thread_id" ] || continue
    name=$(session_name_for_thread "$thread_id" || true)
    if [ -n "$name" ]; then
      printf '%s' "$name"
      return 0
    fi
  done < <(grep -Eo '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' <<<"$text" | awk '!seen[$0]++')

  return 1
}

build_menu() {
  local menu=""
  local session window_index window_name pane_index pane_id command pane_pid path pane_dead start_command title
  local status target label agent_name display_name

  while IFS=$'\t' read -r session window_index window_name pane_index pane_id command pane_pid path pane_dead start_command title; do
    [ -n "${pane_id:-}" ] || continue
    is_codex_pane "$pane_id" "$command" "$start_command" "$title" || continue

    status=$(pane_status "$pane_id" "$pane_dead")
    target="${session}:${window_index}.${pane_index}"
    agent_name=$(codex_thread_name "$pane_id" || true)
    if [ -n "$agent_name" ]; then
      display_name="$agent_name"
    else
      display_name="$target"
    fi
    label=$(printf '%s  %-36s %-18s %s' "$status" "$display_name" "$target" "$(short_path "$path")")
    menu+="${label}"$'\t'"${pane_id}"$'\t'"${session}"$'\t'"${window_index}"$'\t'"${pane_index}"$'\n'
  done < <(tmux list-panes -a -F '#{session_name}	#{window_index}	#{window_name}	#{pane_index}	#{pane_id}	#{pane_current_command}	#{pane_pid}	#{pane_current_path}	#{pane_dead}	#{pane_start_command}	#{pane_title}')

  printf '%s' "$menu" | LC_ALL=C sort -u
}

menu=$(build_menu)

if [ "${1:-}" = "--list" ]; then
  printf '%s' "$menu" | cut -f1
  exit 0
fi

if [ "${1:-}" = "--menu" ]; then
  printf '%s' "$menu"
  exit 0
fi

if [ "${1:-}" = "--reload" ]; then
  sleep "${CODEX_AGENT_REFRESH_SECONDS:-2}"
  exec "$0" --menu
fi

if [ -z "$menu" ]; then
  printf 'No Codex panes found.\n'
  read -r -p "Press enter to close..."
  exit 0
fi

script_path=$(readlink -f "$0" 2>/dev/null || printf '%s' "$0")
refresh_seconds="${CODEX_AGENT_REFRESH_SECONDS:-2}"
reload_command=$(printf '%q --reload' "$script_path")
header=$(printf '\033[34m●\033[0m working   \033[33m●\033[0m waiting   \033[32m●\033[0m idle   \033[31m●\033[0m dead   auto-refresh %ss' "$refresh_seconds")

selection=$(printf '%s' "$menu" | fzf --ansi --height 100% --delimiter=$'\t' --with-nth=1 --prompt="Codex agent> " --header="$header" --track --info=hidden --no-separator --pointer='>' --no-mouse --bind "load:reload($reload_command)")
[ -z "$selection" ] && exit 0

pane_id=$(printf '%s' "$selection" | cut -f2)
session=$(printf '%s' "$selection" | cut -f3)
window_index=$(printf '%s' "$selection" | cut -f4)
pane_index=$(printf '%s' "$selection" | cut -f5)

tmux select-window -t "${session}:${window_index}"
tmux select-pane -t "$pane_id"

if [ -z "${TMUX:-}" ]; then
  tmux attach -t "$session"
else
  tmux switch-client -t "$session"
  tmux select-window -t "${session}:${window_index}"
  tmux select-pane -t "$pane_index"
fi
