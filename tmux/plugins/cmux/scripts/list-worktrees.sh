#!/usr/bin/env bash

current_session="$1"

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
        printf 'worktree|%s|%s|active\t  \033[32m●\033[0m %s (\033[33m%s\033[0m)\n' "$root" "$sess" "$wt_name" "$sess"
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
