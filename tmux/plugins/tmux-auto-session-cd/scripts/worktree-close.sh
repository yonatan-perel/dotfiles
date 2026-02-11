#!/usr/bin/env bash

worktree_close() {
    local session_name="$1"
    local no_confirm="$2"

    if [ -z "$session_name" ]; then
        echo "Error: session name required"
        return 1
    fi

    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Session '$session_name' does not exist"
        return 1
    fi

    if [ "$no_confirm" != "--no-confirm" ]; then
        printf "Close session '$session_name'? (y/N) "
        read -rsn1 confirm < /dev/tty
        echo
        if [ "$confirm" != "y" ]; then
            echo "Cancelled"
            return 0
        fi
    fi

    local current_session=$(tmux display-message -p '#S' 2>/dev/null)

    if [ "$current_session" = "$session_name" ]; then
        local other=$(tmux list-sessions -F '#S' 2>/dev/null | grep -v "^${session_name}$" | head -1)
        if [ -n "$other" ]; then
            tmux switch-client -t "$other"
        fi
    fi

    tmux kill-session -t "$session_name"
    echo "Session '$session_name' closed"
}

worktree_close "$@"
