#!/usr/bin/env bash

if [ "$1" = "init_pane" ]; then
    session_dir=$(tmux show-environment -t "$TMUX_PANE" SESSION_ROOT_DIR 2>/dev/null | cut -d= -f2-)
    if [ -n "$session_dir" ] && [ -d "$session_dir" ]; then
        tmux send-keys -t "$TMUX_PANE" "cd '$session_dir'" C-m

        main_repo_dir="$session_dir"
        if [ -f "$session_dir/.git" ] && git -C "$session_dir" rev-parse --git-dir > /dev/null 2>&1; then
            git_common_dir=$(cd "$session_dir" && git rev-parse --git-common-dir 2>/dev/null)
            if [ -n "$git_common_dir" ]; then
                main_repo_dir=$(cd "$session_dir" && cd "$git_common_dir/.." && pwd)
            fi
        fi

        if [ -f "$session_dir/.env" ]; then
            tmux send-keys -t "$TMUX_PANE" "set -a && source .env && set +a" C-m
        fi
        if [ -f "$main_repo_dir/.env.me" ]; then
            tmux send-keys -t "$TMUX_PANE" "set -a && source '$main_repo_dir/.env.me' && set +a" C-m
        fi
        tmux send-keys -t "$TMUX_PANE" "clear" C-m
    fi
    exit 0
fi

_auto_session_cd_setup() {
    if [ -z "$TMUX" ]; then
        return
    fi

    _auto_session_cd_initialized=$(tmux show-environment SESSION_INITIALIZED 2>/dev/null | cut -d= -f2-)

    if [ "$_auto_session_cd_initialized" = "1" ]; then
        session_dir=$(tmux show-environment SESSION_ROOT_DIR 2>/dev/null | cut -d= -f2-)
        if [ -n "$session_dir" ] && [ -d "$session_dir" ]; then
            cd "$session_dir"

            local main_repo_dir="$session_dir"
            if [ -f "$session_dir/.git" ] && git rev-parse --git-dir > /dev/null 2>&1; then
                local git_common_dir=$(git rev-parse --git-common-dir 2>/dev/null)
                if [ -n "$git_common_dir" ]; then
                    main_repo_dir=$(cd "$git_common_dir/.." && pwd)
                fi
            fi

            if [ -f "$session_dir/.env" ]; then
                set -a && source .env && set +a
            fi
            if [ -f "$main_repo_dir/.env.me" ]; then
                set -a && source "$main_repo_dir/.env.me" && set +a
            fi
        fi
        return
    fi
}

_auto_session_cd_setup

tcs() {
    local script_path=$(tmux show-environment -g TMUX_AUTO_SESSION_CREATE_SCRIPT 2>/dev/null | cut -d= -f2-)
    if [ -z "$script_path" ]; then
        script_path="$HOME/.config/tmux/plugins/cmux/scripts/create-session.sh"
    fi

    if [ -f "$script_path" ]; then
        "$script_path" "$@"
    else
        echo "Error: create-session.sh not found"
        return 1
    fi
}

tds() {
    local script_path=$(tmux show-environment -g TMUX_AUTO_SESSION_DESTROY_SCRIPT 2>/dev/null | cut -d= -f2-)
    if [ -z "$script_path" ]; then
        script_path="$HOME/.config/tmux/plugins/cmux/scripts/destroy-session.sh"
    fi

    if [ -f "$script_path" ]; then
        "$script_path" "$@"
    else
        echo "Error: destroy-session.sh not found"
        return 1
    fi
}
