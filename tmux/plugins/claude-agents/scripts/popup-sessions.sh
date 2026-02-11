#!/bin/bash
# Show popup with Claude Code sessions using fzf

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
    --height=100% \
    --reverse \
    --ansi \
    --prompt="Claude Sessions > " \
    --no-header \
    --bind='ctrl-j:down,ctrl-k:up' \
    --bind="ctrl-a:execute-silent(bash $SCRIPT_DIR/toggle-attention.sh {2})+reload(bash $SCRIPT_DIR/build-popup-list.sh)" \
    --delimiter='\|' \
    --with-nth=6 \
    --no-info \
    --pointer="▶" \
    --color=16)

if [ -z "$SELECTED" ]; then
    exit 0
fi

PANE_ID=$(echo "$SELECTED" | cut -d'|' -f2)
WINDOW_ID=$(echo "$SELECTED" | cut -d'|' -f3)
SESSION_NAME=$(echo "$SELECTED" | cut -d'|' -f4)

if [ -n "$PANE_ID" ] && [ "$PANE_ID" != "null" ]; then
    tmux switch-client -t "$SESSION_NAME"
    tmux select-window -t "$WINDOW_ID"
    tmux select-pane -t "$PANE_ID"
fi
