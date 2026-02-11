#!/bin/bash
STATE_FILE="/tmp/claude-agents-state.json"
HOOK_STATE_DIR="/tmp/claude-agents"

PANES=$(tmux list-panes -a -F "#{session_name}|#{window_id}|#{window_name}|#{pane_id}|#{pane_title}|#{pane_current_command}|#{pane_current_path}|#{pane_pid}" 2>/dev/null)

if [ -z "$PANES" ]; then
    echo '{"sessions":[],"updated_at":""}' > "$STATE_FILE"
    exit 0
fi

SESSIONS_NDJSON=""
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

while IFS='|' read -r session_name window_id window_name pane_id pane_title pane_cmd pane_path pane_pid; do
    HOOK_STATE_FILE="$HOOK_STATE_DIR/${pane_id}.state"
    HAS_HOOK_STATE=false
    [ -f "$HOOK_STATE_FILE" ] && HAS_HOOK_STATE=true

    if ! $HAS_HOOK_STATE && ! [[ "$pane_cmd" =~ claude|node ]] && ! [[ "$pane_title" =~ [Cc]laude ]]; then
        continue
    fi

    IS_CLAUDE=$HAS_HOOK_STATE
    if ! $IS_CLAUDE; then
        PANE_PID="$pane_pid"
        if [ -n "$PANE_PID" ]; then
            if ps -o command= -p "$PANE_PID" 2>/dev/null | grep -qi claude || \
               pgrep -P "$PANE_PID" 2>/dev/null | xargs ps -o command= -p 2>/dev/null | grep -qi claude; then
                IS_CLAUDE=true
            fi
        fi
    fi

    if ! $IS_CLAUDE; then
        continue
    fi

    PROJECT=$(basename "$pane_path")
    STATE="running"
    PRIORITY=2

    if $HAS_HOOK_STATE; then
        HOOK_STATE=$(cat "$HOOK_STATE_FILE" 2>/dev/null)
        case "$HOOK_STATE" in
            attention)
                STATE="confirmation"
                PRIORITY=0
                ;;
            idle)
                STATE="idle"
                PRIORITY=1
                ;;
        esac
    else
        if [[ "$pane_title" =~ [⠀-⣿] ]]; then
            STATE="running"
            PRIORITY=2
        elif [[ "$pane_title" =~ ^[[:space:]]*✳ ]]; then
            STATE="idle"
            PRIORITY=1
        fi
    fi

    SESSIONS_NDJSON+="${session_name}	${window_id}	${window_name}	${pane_id}	${pane_title}	${PROJECT}	${pane_path}	${STATE}	${PRIORITY}
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
            priority: (.[8] | tonumber)
        }] | {sessions: (. | sort_by(.priority)), updated_at: $time}' > "$STATE_FILE"
fi
