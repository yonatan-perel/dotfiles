#!/bin/bash
# Jump to the next Claude session that needs attention

STATE_FILE="/tmp/claude-agents-state.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

bash "$SCRIPT_DIR/scan-sessions.sh"

if [ ! -f "$STATE_FILE" ]; then
    tmux display-message -d 1500 "No Claude sessions found"
    exit 0
fi

AGENT=$(jq -r '.sessions[] | select(.state == "attention") | @json' "$STATE_FILE" 2>/dev/null | head -1)

if [ -z "$AGENT" ] || [ "$AGENT" = "null" ]; then
    tmux display-message -d 1500 "No Claude sessions need attention"
    exit 0
fi

IFS=$'\t' read -r SESSION_NAME WINDOW_ID PANE_ID WINDOW_NAME PANE_TITLE < <(
    echo "$AGENT" | jq -r '[.session_name, .window_id, .pane_id, .window_name, .pane_title] | @tsv'
)

if ! tmux list-panes -a -F "#{pane_id}" | grep -q "^${PANE_ID}$"; then
    tmux display-message -d 1500 "Pane no longer exists"
    exit 1
fi

tmux switch-client -t "$SESSION_NAME"
tmux select-window -t "$WINDOW_ID"
tmux select-pane -t "$PANE_ID"
tmux display-message -d 1500 "→ ${PANE_TITLE} [${SESSION_NAME}:${WINDOW_NAME}]"
