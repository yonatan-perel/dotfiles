#!/usr/bin/env bash

# Common session setup logic used by both auto-cd and explicit session creation
# Usage: setup-session.sh <session_name> <target_path>

setup_session() {
    local session_name="$1"
    local target_path="$2"

    if [ -z "$session_name" ] || [ -z "$target_path" ]; then
        echo "Error: session_name and target_path required"
        return 1
    fi

    # Determine main repo directory (for .env.me)
    local main_repo_dir="$target_path"
    if [ -f "$target_path/.git" ] && git -C "$target_path" rev-parse --git-dir > /dev/null 2>&1; then
        local git_common_dir=$(cd "$target_path" && git rev-parse --git-common-dir 2>/dev/null)
        if [ -n "$git_common_dir" ]; then
            main_repo_dir=$(cd "$target_path" && cd "$git_common_dir/.." && pwd)
        fi
    fi

    # Source .env files in the first window
    local needs_clear=false
    if [ -f "$target_path/.env" ]; then
        tmux send-keys -t "$session_name:1" "set -a && source .env && set +a" C-m
        needs_clear=true
    fi
    if [ -f "$main_repo_dir/.env.me" ]; then
        tmux send-keys -t "$session_name:1" "set -a && source '$main_repo_dir/.env.me' && set +a" C-m
        needs_clear=true
    fi
    if [ "$needs_clear" = true ]; then
        tmux send-keys -t "$session_name:1" "clear" C-m
    fi

    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local win_idx=1

    while IFS=$'\t' read -r wname wcmd; do
        [ -z "$wname" ] && continue
        if [ "$win_idx" -eq 1 ]; then
            tmux rename-window -t "$session_name:1" "$wname"
        else
            tmux new-window -t "$session_name" -n "$wname" -c "$target_path"
        fi
        if [ -n "$wcmd" ]; then
            tmux send-keys -t "$session_name:$win_idx" "$wcmd" C-m
        fi
        win_idx=$((win_idx + 1))
    done < <(bash "$script_dir/parse-config.sh" windows)

    local bot_name=$'\U000f06a9'
    if [ "$win_idx" -eq 1 ]; then
        tmux rename-window -t "$session_name:1" "$bot_name"
    else
        tmux new-window -t "$session_name" -n "$bot_name" -c "$target_path"
    fi
    tmux send-keys -t "$session_name:$win_idx" "claude" C-m
    local agent_win=$win_idx

    tmux select-window -t "$session_name:$agent_win"
}

setup_session "$@"
