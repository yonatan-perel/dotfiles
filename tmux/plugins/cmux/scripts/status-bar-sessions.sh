#!/bin/bash
# Status bar indicator for Claude Code sessions with state colors

STATE_FILE="/tmp/claude-agents-state.json"

if [ ! -f "$STATE_FILE" ]; then
    exit 0
fi

CURRENT_SESSION=$(tmux display-message -p '#S' 2>/dev/null)

# Count by state (global + current session)
COUNTS=$(jq -r --arg sess "$CURRENT_SESSION" '[
    ([.sessions[] | select(.state == "attention")] | length | tostring),
    ([.sessions[] | select(.state == "idle")] | length | tostring),
    ([.sessions[] | select(.state == "running")] | length | tostring),
    ([.sessions[] | select(.state == "attention" and .session_name == $sess)] | length | tostring),
    ([.sessions[] | select(.state == "idle" and .session_name == $sess)] | length | tostring),
    ([.sessions[] | select(.state == "running" and .session_name == $sess)] | length | tostring)
] | join(" ")' "$STATE_FILE" 2>/dev/null) || COUNTS="0 0 0 0 0 0"
read -r ATTENTION IDLE RUNNING S_ATTENTION S_IDLE S_RUNNING <<< "$COUNTS"

format_counts() {
    local attn="$1" idle="$2" running="$3" result=""
    [ "$attn" -gt 0 ] && result+="#[fg=yellow,bold]⚠${attn}#[default]"
    [ "$idle" -gt 0 ] && { [ -n "$result" ] && result+=" "; result+="#[fg=green]✓${idle}#[default]"; }
    [ "$running" -gt 0 ] && { [ -n "$result" ] && result+=" "; result+="#[fg=blue]⟳${running}#[default]"; }
    printf '%s' "$result"
}

OUTPUT=$(format_counts "$ATTENTION" "$IDLE" "$RUNNING")

if [ -n "$OUTPUT" ] && \
   [ "$S_ATTENTION" != "$ATTENTION" -o "$S_IDLE" != "$IDLE" -o "$S_RUNNING" != "$RUNNING" ]; then
    SESS_OUTPUT=$(format_counts "$S_ATTENTION" "$S_IDLE" "$S_RUNNING")
    if [ -n "$SESS_OUTPUT" ]; then
        OUTPUT+=" #[default](${SESS_OUTPUT}#[default])"
    else
        OUTPUT+=" #[default](#[dim]0#[default])"
    fi
fi

# Only show if there are sessions
if [ -n "$OUTPUT" ]; then
    TOTAL=$((ATTENTION + IDLE + RUNNING))
    ICON=$'\xf3\xb1\x9a\x9f'
    echo "${TOTAL}_${ICON}  ${OUTPUT}"
fi
