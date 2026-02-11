#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

create_script=$(tmux show-environment -g TMUX_AUTO_SESSION_CREATE_SCRIPT 2>/dev/null | cut -d= -f2-)
if [ -z "$create_script" ]; then
    create_script="$SCRIPT_DIR/create-session.sh"
fi

current_session=$(tmux display-message -p '#S')
tmp_action=$(mktemp)
trap "rm -f '$tmp_action'" EXIT

pk="a,b,c,e,f,g,h,i,l,m,o,p,r,s,t,u,v,w,z,0,1,2,3,4,5,6,7,8,9,space"
ib="${pk//,/:ignore,}:ignore"

while true; do
    clear
    entries=$(bash "$SCRIPT_DIR/list-worktrees.sh" "$current_session")

    if [ -z "$entries" ]; then
        echo "No worktrees found"
        exit 0
    fi

    echo "" > "$tmp_action"

    selected=$(printf '%s' "$entries" | fzf --ansi \
        --sync \
        --disabled \
        --layout=reverse \
        --delimiter $'\t' \
        --with-nth 2 \
        --no-sort \
        --no-info \
        --no-header \
        --prompt '  ' \
        --bind "$ib" \
        --bind "start:pos(2)" \
        --bind 'j:down,k:up,q:abort' \
        --bind "/:unbind(j,k,d,x,q,$pk)+enable-search+transform-prompt(printf '/ ')" \
        --bind "esc:rebind(j,k,d,x,q,/,$pk)+disable-search+clear-query+transform-prompt(printf '  ')" \
        --bind "d:execute-silent(echo close > '$tmp_action')+accept" \
        --bind "x:execute-silent(echo remove > '$tmp_action')+accept")

    if [ -z "$selected" ]; then
        exit 0
    fi

    read -r action < "$tmp_action" 2>/dev/null

    meta="${selected%%	*}"
    IFS='|' read -r type path session status base_repo <<< "$meta"

    if [ "$action" = "close" ]; then
        if [ "$type" = "worktree" ] && [ -n "$session" ]; then
            clear
            printf "\n  Close session '\033[33m%s\033[0m'? (y/n) " "$session"
            read -rsn1 confirm < /dev/tty
            if [ "$confirm" = "y" ]; then
                bash "$SCRIPT_DIR/worktree-close.sh" "$session" --no-confirm > /dev/null 2>&1
            fi
        fi
        continue
    elif [ "$action" = "remove" ]; then
        if [ "$type" = "worktree" ]; then
            clear
            printf "\n  Remove worktree '\033[33m%s\033[0m'? (y/n) " "${path##*/}"
            read -rsn1 confirm < /dev/tty
            if [ "$confirm" = "y" ]; then
                printf "\n\n  \033[90mRemoving...\033[0m"
                bash "$SCRIPT_DIR/worktree-remove.sh" "$path" "$session" --no-confirm "$base_repo" > /dev/null 2>&1
                printf "\r  \033[32mRemoved.\033[0m  "
                sleep 0.5
            fi
        fi
        continue
    fi

    if [ "$type" = "header" ]; then
        continue
    fi

    if [ "$status" = "active" ] && [ -n "$session" ]; then
        tmux switch-client -t "$session"
    else
        bash "$create_script" "$path"
    fi
    break
done
