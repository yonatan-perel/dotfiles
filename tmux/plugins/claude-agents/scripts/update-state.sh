#!/bin/bash
HOOK_TYPE="${1:-unknown}"
STATE_DIR="/tmp/claude-agents"

cat > /dev/null

mkdir -p "$STATE_DIR"

if [ "$HOOK_TYPE" = "focus" ]; then
    PANE_ID=$(tmux display-message -p '#{pane_id}' 2>/dev/null)
    STATE_FILE="$STATE_DIR/${PANE_ID}.state"
    if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE" 2>/dev/null)" = "attention" ]; then
        echo "idle" > "$STATE_FILE"
        tmux refresh-client -S &
    fi
    exit 0
fi

PANE_ID="${TMUX_PANE}"
if [ -z "$PANE_ID" ]; then
    exit 0
fi

STATE_FILE="$STATE_DIR/${PANE_ID}.state"

set_attention() {
    local msg="$1"
    local session_name=$(tmux display-message -p -t "$PANE_ID" '#{session_name}' 2>/dev/null)
    echo "attention" > "$STATE_FILE"
    terminal-notifier -title "Claude Code" -message "Claude needs your attention in ${session_name}!" -sound default &
    tmux display-message "⚠ Claude needs your attention in ${session_name}!" &
    tmux refresh-client -S &
}

echo "$(date +%H:%M:%S) hook=$HOOK_TYPE pane=$PANE_ID" >> "$STATE_DIR/debug.log"

case "$HOOK_TYPE" in
    session_start)
        echo "idle" > "$STATE_FILE"
        ;;
    prompt_submit|running)
        echo "running" > "$STATE_FILE"
        ;;
    stop)
        if tmux list-panes -a -F '#{pane_active}#{window_active}#{session_attached} #{pane_id}' 2>/dev/null | grep -q "^111 ${PANE_ID}$"; then
            echo "idle" > "$STATE_FILE"
        else
            set_attention "Session finished"
        fi
        tmux refresh-client -S &
        ;;
    exit)
        rm -f "$STATE_FILE"
        tmux refresh-client -S &
        ;;
    notification)
        set_attention "Session needs your attention"
        ;;
esac
