#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux set-hook -g after-new-window "run-shell '$CURRENT_DIR/scripts/auto-session-cd.sh init_pane'"
tmux set-hook -g after-split-window "run-shell '$CURRENT_DIR/scripts/auto-session-cd.sh init_pane'"

tmux set-environment -g TMUX_AUTO_SESSION_CD_PLUGIN "$CURRENT_DIR/scripts/auto-session-cd.sh"

# Export new script paths
tmux set-environment -g TMUX_AUTO_SESSION_CREATE_SCRIPT "$CURRENT_DIR/scripts/create-session.sh"
tmux set-environment -g TMUX_AUTO_SESSION_DESTROY_SCRIPT "$CURRENT_DIR/scripts/destroy-session.sh"

# Key bindings
tmux bind-key N command-prompt -p "Create session at path:" "run-shell '$CURRENT_DIR/scripts/create-session.sh \"%%\"'"
tmux bind-key D run-shell "$CURRENT_DIR/scripts/destroy-session.sh"
tmux bind-key s display-popup -E -w 70% -h 60% "bash $CURRENT_DIR/scripts/worktree-browser.sh"
