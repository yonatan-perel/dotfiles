#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux set-hook -g after-new-window "run-shell '$CURRENT_DIR/scripts/auto-session-cd.sh init_pane'"
tmux set-hook -g after-split-window "run-shell '$CURRENT_DIR/scripts/auto-session-cd.sh init_pane'"

tmux set-environment -g TMUX_AUTO_SESSION_CD_PLUGIN "$CURRENT_DIR/scripts/auto-session-cd.sh"
