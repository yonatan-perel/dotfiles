#!/bin/bash
# Jump to the next Claude session that needs attention

STATE_FILE="/tmp/claude-agents-state.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK_STATE_DIR="/tmp/claude-agents"

bash "$SCRIPT_DIR/scan-sessions.sh"

if [ ! -f "$STATE_FILE" ]; then
    tmux display-message -d 1500 "No Claude sessions found"
    exit 0
fi

AGENT=$(jq -r '.sessions[] | select(.state == "confirmation") | @json' "$STATE_FILE" 2>/dev/null | head -1)

if [ -z "$AGENT" ] || [ "$AGENT" = "null" ]; then
    tmux display-message -d 1500 "No Claude sessions need attention"
    exit 0
fi

SESSION_NAME=$(echo "$AGENT" | jq -r '.session_name')
WINDOW_ID=$(echo "$AGENT" | jq -r '.window_id')
PANE_ID=$(echo "$AGENT" | jq -r '.pane_id')
PANE_TITLE=$(echo "$AGENT" | jq -r '.pane_title')
WINDOW_NAME=$(echo "$AGENT" | jq -r '.window_name')

if ! tmux list-panes -a -F "#{pane_id}" | grep -q "^${PANE_ID}$"; then
    tmux display-message -d 1500 "Pane no longer exists"
    exit 1
fi

STATE="${HOOK_STATE_DIR}/${PANE_ID}.state"
if [ -f "$STATE" ] && [ "$(cat "$STATE" 2>/dev/null)" = "attention" ]; then
    echo "idle" > "$STATE"
fi

tmux switch-client -t "$SESSION_NAME"
tmux select-window -t "$WINDOW_ID"
tmux select-pane -t "$PANE_ID"
tmux display-message -d 1500 "→ ${PANE_TITLE} [${SESSION_NAME}:${WINDOW_NAME}]"
