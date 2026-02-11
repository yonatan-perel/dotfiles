#!/bin/bash
# Show popup with Claude Code sessions using fzf

STATE_FILE="/tmp/claude-agents-state.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Scan for latest sessions
bash "$SCRIPT_DIR/scan-sessions.sh"

# Check if state file exists
if [ ! -f "$STATE_FILE" ]; then
    echo "No Claude Code sessions found"
    sleep 2
    exit 0
fi

# Get session count
SESSION_COUNT=$(jq '.sessions | length' "$STATE_FILE" 2>/dev/null || echo 0)

if [ "$SESSION_COUNT" -eq 0 ]; then
    echo "No Claude Code sessions found"
    sleep 2
    exit 0
fi

# Build fzf input with format: index|pane_id|window_id|session_name|state|display_text
# Add colored indicator based on state
NOW=$(date +%s)
SESSIONS=$(jq -r --argjson now "$NOW" '.sessions | to_entries[] |
    (.value.last_changed // $now) as $lc |
    (($now - $lc) | if . < 60 then "\(.)s"
     elif . < 3600 then "\(. / 60 | floor)m"
     elif . < 86400 then "\(. / 3600 | floor)h"
     else "\(. / 86400 | floor)d" end) as $ago |
    if .value.state == "confirmation" then
        "\(.key)|\(.value.pane_id)|\(.value.window_id)|\(.value.session_name)|confirmation|⚠ \($ago) ago · \(.value.pane_title) [\(.value.project)]"
    elif .value.state == "idle" then
        "\(.key)|\(.value.pane_id)|\(.value.window_id)|\(.value.session_name)|idle|✓ \($ago) ago · \(.value.pane_title) [\(.value.project)]"
    else
        "\(.key)|\(.value.pane_id)|\(.value.window_id)|\(.value.session_name)|running|⟳ \($ago) ago · \(.value.pane_title) [\(.value.project)]"
    end' "$STATE_FILE")

# Use fzf for selection with vim keybindings and ANSI colors
SELECTED=$(echo "$SESSIONS" | fzf \
    --height=100% \
    --reverse \
    --ansi \
    --prompt="Claude Sessions > " \
    --header="⚠=needs attention | ✓=idle | ⟳=running | C-j/k: navigate | Enter: jump" \
    --bind='ctrl-j:down,ctrl-k:up' \
    --delimiter='\|' \
    --with-nth=6 \
    --no-info \
    --pointer="▶" \
    --color=16)

# Exit if nothing selected
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Parse selection
PANE_ID=$(echo "$SELECTED" | cut -d'|' -f2)
WINDOW_ID=$(echo "$SELECTED" | cut -d'|' -f3)
SESSION_NAME=$(echo "$SELECTED" | cut -d'|' -f4)

# Jump to the selected session
if [ -n "$PANE_ID" ] && [ "$PANE_ID" != "null" ]; then
    tmux switch-client -t "$SESSION_NAME"
    tmux select-window -t "$WINDOW_ID"
    tmux select-pane -t "$PANE_ID"
fi
