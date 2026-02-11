#!/bin/bash
STATE_FILE="/tmp/claude-agents-state.json"
HOOK_STATE_DIR="/tmp/claude-agents"

PANES=$(tmux list-panes -a -F "#{session_name}|#{window_id}|#{window_name}|#{pane_id}|#{pane_title}|#{pane_current_path}" 2>/dev/null)

if [ -z "$PANES" ]; then
    echo '{"sessions":[],"updated_at":""}' > "$STATE_FILE"
    exit 0
fi

SESSIONS_NDJSON=""
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

while IFS='|' read -r session_name window_id window_name pane_id pane_title pane_path; do
    HOOK_STATE_FILE="$HOOK_STATE_DIR/${pane_id}.state"
    [ -f "$HOOK_STATE_FILE" ] || continue

    PROJECT=$(basename "$pane_path")
    STATE="running"
    PRIORITY=1
    LAST_CHANGED=$(stat -f %m "$HOOK_STATE_FILE" 2>/dev/null || date +%s)
    HOOK_STATE=$(cat "$HOOK_STATE_FILE" 2>/dev/null)

    case "$HOOK_STATE" in
        attention)
            STATE="confirmation"
            PRIORITY=0
            ;;
        idle)
            STATE="idle"
            PRIORITY=2
            ;;
    esac

    SESSIONS_NDJSON+="${session_name}	${window_id}	${window_name}	${pane_id}	${pane_title}	${PROJECT}	${pane_path}	${STATE}	${PRIORITY}	${LAST_CHANGED}
"
done <<< "$PANES"

if [ -z "$SESSIONS_NDJSON" ]; then
    echo "{\"sessions\":[],\"updated_at\":\"$TIMESTAMP\"}" > "$STATE_FILE"
else
    printf '%s' "$SESSIONS_NDJSON" | jq -Rn --arg time "$TIMESTAMP" '
        [inputs | split("\t") | {
            session_name: .[0],
            window_id: .[1],
            window_name: .[2],
            pane_id: .[3],
            pane_title: .[4],
            project: .[5],
            path: .[6],
            state: .[7],
            priority: (.[8] | tonumber),
            last_changed: (.[9] | tonumber)
        }] | {sessions: (. | sort_by(.priority, -.last_changed)), updated_at: $time}' > "$STATE_FILE"
fi
