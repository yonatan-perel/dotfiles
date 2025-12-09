#!/usr/bin/env bash

if [ "$1" = "init_pane" ]; then
    session_dir=$(tmux show-environment -t "$TMUX_PANE" SESSION_ROOT_DIR 2>/dev/null | cut -d= -f2-)
    if [ -n "$session_dir" ] && [ -d "$session_dir" ]; then
        tmux send-keys -t "$TMUX_PANE" "cd '$session_dir'" C-m
        if [ -f "$session_dir/.env" ]; then
            tmux send-keys -t "$TMUX_PANE" "source .env" C-m
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
            if [ -f "$session_dir/.env" ]; then
                source .env
            fi
        fi
        return
    fi

    _auto_session_cd_hook() {
        local initialized=$(tmux show-environment SESSION_INITIALIZED 2>/dev/null | cut -d= -f2-)

        if [ "$initialized" != "1" ]; then
            local current_dir="$PWD"

            if git rev-parse --git-dir > /dev/null 2>&1; then
                local dir_name=$(basename "$current_dir")

                if [ -n "$dir_name" ]; then
                    tmux rename-session "$dir_name"
                    tmux set-environment SESSION_ROOT_DIR "$current_dir"
                    tmux set-environment SESSION_INITIALIZED "1"

                    if [ -f "$current_dir/.env" ]; then
                        source .env
                    fi

                    tmux rename-window "vim"
                    tmux new-window -n "cli"
                    tmux new-window -n "agent"
                    tmux select-window -t 1
                fi
            fi
        fi
    }

    if [[ -n "$ZSH_VERSION" ]]; then
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd _auto_session_cd_hook
    fi
}

_auto_session_cd_setup
