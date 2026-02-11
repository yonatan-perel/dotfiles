#!/bin/bash
# Claude Agents tmux plugin - tracks Claude Code sessions

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Make scripts executable
chmod +x "$CURRENT_DIR/scripts/"*.sh

# Set up keybinding to show popup (prefix + a)
tmux bind-key a display-popup -E -w 80% -h 80% "bash $CURRENT_DIR/scripts/popup-sessions.sh"

# Jump to next session needing attention (prefix + A)
tmux bind-key A run-shell "bash $CURRENT_DIR/scripts/jump-to-attention.sh"

# Add status bar indicator with periodic scanning
STATUS_RIGHT=$(tmux show-option -gv status-right)

# Check if our indicator is already in status-right
if [[ ! "$STATUS_RIGHT" =~ claude-agents ]]; then
    # Insert before existing status-right content
    NEW_STATUS_RIGHT="#(bash $CURRENT_DIR/scripts/scan-sessions.sh >/dev/null 2>&1; bash $CURRENT_DIR/scripts/status-bar-sessions.sh) | $STATUS_RIGHT"
    tmux set-option -g status-right "$NEW_STATUS_RIGHT"
fi

# Set status interval for updates (every 2 seconds)
tmux set-option -g status-interval 2

# Clear attention state when focusing a Claude pane
tmux set-hook -g window-pane-changed "run-shell -b 'bash $CURRENT_DIR/scripts/update-state.sh focus'"
tmux set-hook -g session-window-changed "run-shell -b 'bash $CURRENT_DIR/scripts/update-state.sh focus'"
