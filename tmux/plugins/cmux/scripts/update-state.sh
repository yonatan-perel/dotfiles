#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/icons.sh"
HOOK_TYPE="${1:-unknown}"
STATE_DIR="/tmp/claude-agents"

mkdir -p "$STATE_DIR"

if [ "$HOOK_TYPE" = "dismiss" ]; then
    PANE_ID=$(tmux display-message -p '#{pane_id}' 2>/dev/null)
    STATE_FILE="$STATE_DIR/${PANE_ID}.state"
    if [ -f "$STATE_FILE" ]; then
        CURRENT=$(cat "$STATE_FILE" 2>/dev/null)
        WINDOW_NAME=$(tmux display-message -p '#{window_name}' 2>/dev/null)
        PANE_TITLE=$(tmux display-message -p '#{pane_title}' 2>/dev/null | sed 's/^[^[:alnum:]]* *//')
        if [ "$CURRENT" = "attention" ]; then
            echo "idle" > "$STATE_FILE"
            dismiss_notification "cmux-${PANE_ID}"
            tmux display-message -d 1500 "${ICON_IDLE} ${WINDOW_NAME} ${PANE_TITLE}"
        else
            echo "attention" > "$STATE_FILE"
            tmux display-message -d 1500 "${ICON_ATTENTION} ${WINDOW_NAME} ${PANE_TITLE}"
        fi
        tmux refresh-client -S &
    fi
    exit 0
fi

cat > /dev/null

PANE_ID="${TMUX_PANE}"
if [ -z "$PANE_ID" ]; then
    exit 0
fi

STATE_FILE="$STATE_DIR/${PANE_ID}.state"

terminal_is_focused() {
    local frontmost="${1:-$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)}"
    [[ "$frontmost" == *wezterm* || "$frontmost" == *Terminal* || "$frontmost" == *iTerm* || "$frontmost" == *kitty* || "$frontmost" == *Alacritty* ]]
}

notify_macos() {
    local title="$1" message="$2" group="$3"
    terminal-notifier \
        -title "$title" \
        -message "$message" \
        -sound default \
        -group "$group" &
}

dismiss_notification() {
    local group="$1"
    terminal-notifier -remove "$group" &>/dev/null &
}

set_attention() {
    local frontmost="$1"
    local session_name=$(tmux display-message -p -t "$PANE_ID" '#{session_name}' 2>/dev/null)
    local window_name=$(tmux display-message -p -t "$PANE_ID" '#{window_name}' 2>/dev/null)
    local pane_title=$(tmux display-message -p -t "$PANE_ID" '#{pane_title}' 2>/dev/null | sed 's/^[^[:alnum:]]* *//')
    echo "attention" > "$STATE_FILE"
    local msg="Bot ${window_name} ${pane_title} [${session_name}] needs attention"
    if ! terminal_is_focused "$frontmost"; then
        notify_macos "🤖 ${pane_title}" "[${session_name}] needs attention" "cmux-${PANE_ID}"
    fi
    tmux display-message -d 1500 "$msg" &
    tmux refresh-client -S &
}

echo "$(date +%H:%M:%S) hook=$HOOK_TYPE pane=$PANE_ID" >> "$STATE_DIR/debug.log"

case "$HOOK_TYPE" in
    session_start)
        echo "idle" > "$STATE_FILE"
        ;;
    prompt_submit|running)
        echo "running" > "$STATE_FILE"
        dismiss_notification "cmux-${PANE_ID}"
        ;;
    stop)
        FRONTMOST=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
        PANE_FOCUSED=$(tmux list-panes -a -F '#{pane_active}#{window_active}#{session_attached} #{pane_id}' 2>/dev/null | grep -q "^111 ${PANE_ID}$" && echo 1)
        if [ "$PANE_FOCUSED" = "1" ] && terminal_is_focused "$FRONTMOST"; then
            echo "idle" > "$STATE_FILE"
        else
            set_attention "$FRONTMOST"
        fi
        tmux refresh-client -S &
        ;;
    exit)
        rm -f "$STATE_FILE"
        dismiss_notification "cmux-${PANE_ID}"
        tmux refresh-client -S &
        ;;
    notification)
        set_attention ""
        ;;
esac
