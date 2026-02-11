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

    # Setup windows
    tmux rename-window -t "$session_name:1" "agent"
    tmux send-keys -t "$session_name:1" "claude" C-m
    tmux new-window -t "$session_name" -n "cli" -c "$target_path"
    tmux new-window -t "$session_name" -n "vim" -c "$target_path"
    tmux send-keys -t "$session_name:2" "mise trust" C-m
    tmux select-window -t "$session_name:1"
}

setup_session "$@"
