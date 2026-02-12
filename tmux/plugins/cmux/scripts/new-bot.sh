#!/usr/bin/env bash

BOTS=($'\U000f06a9' $'\U000f169d' $'\U000f169f' $'\U000f16a1' $'\U000f16a3' $'\U000f1719' $'\U000f16a5' $'\U000ee0d')

session="${1:-$(tmux display-message -p '#S')}"
target_path=$(tmux show-environment -t "$session" SESSION_ROOT_DIR 2>/dev/null | cut -d= -f2-)

used=$(tmux list-windows -t "$session" -F '#W' 2>/dev/null)

for bot in "${BOTS[@]}"; do
    if ! echo "$used" | grep -qxF "$bot"; then
        name="$bot"
        break
    fi
done

if [ -z "$name" ]; then
    name="${BOTS[$((RANDOM % ${#BOTS[@]}))]}"
fi

tmux new-window -t "$session" -n "$name" ${target_path:+-c "$target_path"}
tmux send-keys -t "$session:$name" "claude" C-m
