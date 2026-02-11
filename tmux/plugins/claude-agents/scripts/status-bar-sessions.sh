#!/bin/bash
# Status bar indicator for Claude Code sessions with state colors

STATE_FILE="/tmp/claude-agents-state.json"

if [ ! -f "$STATE_FILE" ]; then
    exit 0
fi

# Count by state
COUNTS=$(jq -r '[
    ([.sessions[] | select(.state == "confirmation")] | length | tostring),
    ([.sessions[] | select(.state == "idle")] | length | tostring),
    ([.sessions[] | select(.state == "running")] | length | tostring)
] | join(" ")' "$STATE_FILE" 2>/dev/null) || COUNTS="0 0 0"
read -r CONFIRMATION IDLE RUNNING <<< "$COUNTS"

# Build status with colors
OUTPUT=""

if [ "$CONFIRMATION" -gt 0 ]; then
    OUTPUT+="#[fg=yellow,bold]⚠${CONFIRMATION}#[default] "
fi

if [ "$IDLE" -gt 0 ]; then
    OUTPUT+="#[fg=green]✓${IDLE}#[default] "
fi

if [ "$RUNNING" -gt 0 ]; then
    OUTPUT+="#[fg=blue]⟳${RUNNING}#[default] "
fi

# Only show if there are sessions
if [ -n "$OUTPUT" ]; then
    echo "🤖 ${OUTPUT}"
fi
