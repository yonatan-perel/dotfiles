#!/usr/bin/env bash

current_session="$1"
if [ -z "$current_session" ]; then
    current_session=$(tmux display-message -p '#S' 2>/dev/null)
fi

CLAUDE_STATE_FILE="/tmp/claude-agents-state.json"

CLAUDE_ENTRIES=""
if [ -f "$CLAUDE_STATE_FILE" ]; then
    NOW=$(date +%s)
    ROBOTS=$(printf '%s' "$(printf '\U000f06a9,\U000f169d,\U000f169f,\U000f16a1,\U000f16a3,\U000f1719,\U000f16a5,\U000ee0d')")
    CLAUDE_ENTRIES=$(jq -r --argjson now "$NOW" --arg robots "$ROBOTS" '
        ($robots | split(",")) as $bots |
        .sessions[] |
        (.last_changed // $now) as $lc |
        (($now - $lc) | if . < 60 then "\(.)s"
         elif . < 3600 then "\(. / 60 | floor)m"
         elif . < 86400 then "\(. / 3600 | floor)h"
         else "\(. / 86400 | floor)d" end) as $ago |
        (.pane_title | gsub("^[^a-zA-Z0-9]+"; "") | if length > 40 then .[:37] + "..." else . end) as $pane |
        (.pane_id | ltrimstr("%") | tonumber % ($bots | length)) as $ri |
        $bots[$ri] as $bot |
        if .state == "attention" then
            "claude|\(.pane_id)|\(.window_id)|\(.session_name)|attention\t    \u001b[33m⚠\u001b[0m \($bot) \($pane) \u001b[90m\($ago)\u001b[0m"
        elif .state == "idle" then
            "claude|\(.pane_id)|\(.window_id)|\(.session_name)|idle\t    \u001b[32m✓\u001b[0m \u001b[90m\($bot) \($pane) \($ago)\u001b[0m"
        else
            "claude|\(.pane_id)|\(.window_id)|\(.session_name)|running\t    \u001b[36m⟳\u001b[0m \($bot) \($pane) \u001b[90m\($ago)\u001b[0m"
        end' "$CLAUDE_STATE_FILE" 2>/dev/null)
fi

sessions=""
repos=""
repo_list=""

while IFS= read -r sess; do
    root=$(tmux show-environment -t "$sess" SESSION_ROOT_DIR 2>/dev/null | cut -d= -f2-)
    if [ -n "$root" ] && [ -d "$root" ]; then
        base_repo="$root"
        if [ -f "$root/.git" ]; then
            common_dir=$(cd "$root" && git rev-parse --git-common-dir 2>/dev/null)
            if [ -n "$common_dir" ]; then
                base_repo=$(cd "$root" && cd "$common_dir/.." && pwd)
            fi
        fi

        sessions+="$sess|$root|$base_repo"$'\n'

        if [[ "$repo_list" != *"|$base_repo|"* ]]; then
            repo_list+="|$base_repo|"
            repos+="$base_repo"$'\n'
        fi
    fi
done < <(tmux list-sessions -F '#{session_name}')

current_repo=""
if [ -n "$current_session" ]; then
    while IFS='|' read -r sess root base; do
        if [ "$sess" = "$current_session" ]; then
            current_repo="$base"
            break
        fi
    done <<< "$sessions"
fi

get_claude_instances() {
    local session_name="$1"
    [ -z "$CLAUDE_ENTRIES" ] && return
    printf '%s\n' "$CLAUDE_ENTRIES" | grep -F "|${session_name}|"
}

output_repo() {
    local repo="$1"
    local repo_name="${repo##*/}"

    printf 'header||%s||%s\t\033[34m── %s ──\033[0m\n' "$repo_name" "$repo" "$repo_name"

    if [ -n "$current_session" ] && [ "$repo" = "$current_repo" ]; then
        while IFS='|' read -r sess root base; do
            if [ "$sess" = "$current_session" ] && [ "$base" = "$repo" ]; then
                local wt_name="${root##*/}"
                [ "$root" = "$repo" ] && wt_name="main"
                printf 'worktree|%s|%s|active|%s\t  \033[32m●\033[0m %s (\033[33m%s\033[0m)\n' "$root" "$sess" "$repo" "$wt_name" "$sess"

                get_claude_instances "$sess"

                break
            fi
        done <<< "$sessions"
    fi

    while IFS='|' read -r sess root base; do
        [ -z "$sess" ] && continue
        [ "$sess" = "$current_session" ] && continue
        [ "$base" != "$repo" ] && continue
        local wt_name="${root##*/}"
        [ "$root" = "$repo" ] && wt_name="main"
        printf 'worktree|%s|%s|active|%s\t  \033[32m●\033[0m %s (\033[33m%s\033[0m)\n' "$root" "$sess" "$repo" "$wt_name" "$sess"

        get_claude_instances "$sess"

    done <<< "$sessions"

    if git -C "$repo" rev-parse --git-dir > /dev/null 2>&1; then
        git -C "$repo" worktree list --porcelain 2>/dev/null | while IFS= read -r line; do
            if [[ "$line" == "worktree "* ]]; then
                local wt_path="${line#worktree }"
                [[ "$sessions" == *"|${wt_path}|"* ]] && continue
                local wt_name="${wt_path##*/}"
                [ "$wt_path" = "$repo" ] && wt_name="main"
                printf 'worktree|%s||inactive|%s\t  \033[90m○ %s\033[0m\n' "$wt_path" "$repo" "$wt_name"
            fi
        done
    fi
}

if [ -n "$current_repo" ]; then
    output_repo "$current_repo"
fi

while IFS= read -r repo; do
    [ -z "$repo" ] && continue
    [ "$repo" = "$current_repo" ] && continue
    output_repo "$repo"
done <<< "$repos"
