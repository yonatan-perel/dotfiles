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

PARTS=()

if [ "$ATTENTION" -gt 0 ]; then
    PARTS+=("#[fg=yellow,bold]⚠${ATTENTION}#[default]")
fi
if [ "$IDLE" -gt 0 ]; then
    PARTS+=("#[fg=green]✓${IDLE}#[default]")
fi
if [ "$RUNNING" -gt 0 ]; then
    PARTS+=("#[fg=blue]⟳${RUNNING}#[default]")
fi

OUTPUT=""
for i in "${!PARTS[@]}"; do
    [ "$i" -gt 0 ] && OUTPUT+=" "
    OUTPUT+="${PARTS[$i]}"
done

# Append current-session counts if different from global
if [ -n "$OUTPUT" ] && \
   [ "$S_ATTENTION" != "$ATTENTION" -o "$S_IDLE" != "$IDLE" -o "$S_RUNNING" != "$RUNNING" ]; then
    S_PARTS=()
    if [ "$S_ATTENTION" -gt 0 ]; then
        S_PARTS+=("#[fg=yellow,bold]⚠${S_ATTENTION}#[default]")
    fi
    if [ "$S_IDLE" -gt 0 ]; then
        S_PARTS+=("#[fg=green]✓${S_IDLE}#[default]")
    fi
    if [ "$S_RUNNING" -gt 0 ]; then
        S_PARTS+=("#[fg=blue]⟳${S_RUNNING}#[default]")
    fi
    SESS_OUTPUT=""
    for i in "${!S_PARTS[@]}"; do
        [ "$i" -gt 0 ] && SESS_OUTPUT+=" "
        SESS_OUTPUT+="${S_PARTS[$i]}"
    done
    if [ -n "$SESS_OUTPUT" ]; then
        OUTPUT+=" #[default](${SESS_OUTPUT}#[default])"
    else
        OUTPUT+=" #[default](#[dim]0#[default])"
    fi
fi

# Only show if there are sessions
if [ -n "$OUTPUT" ]; then
    TOTAL=$((ATTENTION + IDLE + RUNNING))
    THIN_SPACE=$'\xe2\x80\x89'
    ICON=$'\xf3\xb1\x9a\x9f'
    echo "${TOTAL}_${ICON}  ${OUTPUT}"
fi
