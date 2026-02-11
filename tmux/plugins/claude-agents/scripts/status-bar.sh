#!/bin/bash
# Status bar indicator for running Claude agents

STATE_FILE="/tmp/claude-agents-state.json"

if [ ! -f "$STATE_FILE" ]; then
    exit 0
fi

# Count running agents
RUNNING_COUNT=$(jq '[.agents[] | select(.status == "running")] | length' "$STATE_FILE" 2>/dev/null || echo 0)

if [ "$RUNNING_COUNT" -gt 0 ]; then
    # Show indicator with count
    echo "🤖 ${RUNNING_COUNT}"
else
    # No running agents
    echo ""
fi
