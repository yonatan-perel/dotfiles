#!/bin/bash
HOOK_TYPE="${1:-unknown}"
STATE_DIR="/tmp/claude-agents"

cat > /dev/null

mkdir -p "$STATE_DIR"

PANE_ID="${TMUX_PANE}"
if [ -z "$PANE_ID" ]; then
    exit 0
fi

STATE_FILE="$STATE_DIR/${PANE_ID}.state"

echo "$(date +%H:%M:%S) hook=$HOOK_TYPE pane=$PANE_ID" >> "$STATE_DIR/debug.log"

case "$HOOK_TYPE" in
    pre_tool|post_tool|post_tool_fail|prompt_submit)
        echo "running" > "$STATE_FILE"
        ;;
    stop)
        echo "idle" > "$STATE_FILE"
        terminal-notifier -title "Claude Code" -message "Session finished" -sound default &
        tmux display-message "✓ Claude Code session finished" &
        tmux refresh-client -S &
        ;;
    notification)
        echo "attention" > "$STATE_FILE"
        terminal-notifier -title "Claude Code" -message "Session needs your attention" -sound default &
        tmux display-message "⚠ Claude Code needs your attention" &
        tmux refresh-client -S &
        ;;
esac
