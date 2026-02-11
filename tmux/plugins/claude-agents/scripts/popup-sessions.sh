#!/bin/bash

STATE_FILE="/tmp/claude-agents-state.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$STATE_FILE" ]; then
    echo "No Claude Code sessions found"
    sleep 2
    exit 0
fi

SESSION_COUNT=$(jq '.sessions | length' "$STATE_FILE" 2>/dev/null || echo 0)

if [ "$SESSION_COUNT" -eq 0 ]; then
    echo "No Claude Code sessions found"
    sleep 2
    exit 0
fi

SELECTED=$(bash "$SCRIPT_DIR/format-popup-list.sh" | fzf \
    --ansi \
    --disabled \
    --layout=reverse \
    --delimiter $'\t' \
    --with-nth 2 \
    --no-sort \
    --no-info \
    --no-header \
    --bind 'j:down,k:up,q:abort' \
    --bind '/:unbind(j,k,a,q)+enable-search' \
    --bind 'esc:rebind(j,k,a,q)+disable-search+clear-query' \
    --bind "a:execute-silent(
        pane_id=\$(echo {} | cut -f1 | cut -d'|' -f2)
        bash '$SCRIPT_DIR/toggle-attention.sh' \"\$pane_id\"
    )+reload(bash '$SCRIPT_DIR/build-popup-list.sh')")

if [ -z "$SELECTED" ]; then
    exit 0
fi

PANE_ID=$(echo "$SELECTED" | cut -f1 | cut -d'|' -f2)
WINDOW_ID=$(echo "$SELECTED" | cut -f1 | cut -d'|' -f3)
SESSION_NAME=$(echo "$SELECTED" | cut -f1 | cut -d'|' -f4)

if [ -n "$PANE_ID" ] && [ "$PANE_ID" != "null" ]; then
    tmux switch-client -t "$SESSION_NAME"
    tmux select-window -t "$WINDOW_ID"
    tmux select-pane -t "$PANE_ID"
fi
