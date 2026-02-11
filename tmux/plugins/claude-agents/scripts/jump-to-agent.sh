#!/bin/bash
# Jump to a specific agent's pane

STATE_FILE="/tmp/claude-agents-state.json"

if [ ! -f "$STATE_FILE" ]; then
    tmux display-message "No agent state found"
    exit 1
fi

# Get agent by index (1-based)
AGENT_INDEX=$1

if [ -z "$AGENT_INDEX" ]; then
    tmux display-message "Usage: jump-to-agent.sh <index>"
    exit 1
fi

# Get agent info by index (works for both running and completed)
AGENT=$(jq -r ".agents[$((AGENT_INDEX-1))]" "$STATE_FILE")

if [ "$AGENT" = "null" ] || [ -z "$AGENT" ]; then
    tmux display-message "Agent #${AGENT_INDEX} not found"
    exit 1
fi

SESSION_NAME=$(echo "$AGENT" | jq -r '.session_name')
WINDOW_ID=$(echo "$AGENT" | jq -r '.window_id')
PANE_ID=$(echo "$AGENT" | jq -r '.pane_id')

# Check if pane still exists
if ! tmux list-panes -a -F "#{pane_id}" | grep -q "^${PANE_ID}$"; then
    tmux display-message "Agent pane no longer exists"
    exit 1
fi

# Jump to the pane
tmux switch-client -t "$SESSION_NAME"
tmux select-window -t "$WINDOW_ID"
tmux select-pane -t "$PANE_ID"
