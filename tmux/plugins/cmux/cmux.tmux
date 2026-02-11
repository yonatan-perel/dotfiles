#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make scripts executable
chmod +x "$CURRENT_DIR/scripts/"*.sh

# Auto session CD hooks
tmux set-hook -g after-new-window "run-shell '$CURRENT_DIR/scripts/auto-session-cd.sh init_pane'"
tmux set-hook -g after-split-window "run-shell '$CURRENT_DIR/scripts/auto-session-cd.sh init_pane'"

tmux set-environment -g TMUX_AUTO_SESSION_CD_PLUGIN "$CURRENT_DIR/scripts/auto-session-cd.sh"

# Export script paths
tmux set-environment -g TMUX_AUTO_SESSION_CREATE_SCRIPT "$CURRENT_DIR/scripts/create-session.sh"
tmux set-environment -g TMUX_AUTO_SESSION_DESTROY_SCRIPT "$CURRENT_DIR/scripts/destroy-session.sh"

# Key bindings - Session/Worktree management
tmux bind-key N command-prompt -p "Create session at path:" "run-shell '$CURRENT_DIR/scripts/create-session.sh \"%%\"'"
tmux bind-key D run-shell "$CURRENT_DIR/scripts/destroy-session.sh"
tmux bind-key s display-popup -E -w 70% -h 60% "bash $CURRENT_DIR/scripts/unified-browser.sh"

# Key bindings - Claude agents
tmux bind-key C-a run-shell "bash $CURRENT_DIR/scripts/jump-to-attention.sh"
tmux bind-key A run-shell "bash $CURRENT_DIR/scripts/update-state.sh dismiss"

# Add Claude agents status bar indicator
STATUS_RIGHT=$(tmux show-option -gv status-right)

if [[ ! "$STATUS_RIGHT" =~ status-bar-sessions ]]; then
    NEW_STATUS_RIGHT="#(bash $CURRENT_DIR/scripts/scan-sessions.sh >/dev/null 2>&1; bash $CURRENT_DIR/scripts/status-bar-sessions.sh) | $STATUS_RIGHT"
    tmux set-option -g status-right "$NEW_STATUS_RIGHT"
fi

# Set status interval for updates (every 2 seconds)
tmux set-option -g status-interval 2
