#!/usr/bin/env bash

mode="$1"
project_path="$2"

CONFIG_FILE="${CMUX_CONFIG:-$HOME/.config/cmux/cmux.yaml}"

if [ ! -f "$CONFIG_FILE" ]; then
    exit 0
fi

project_name=""
if [ -n "$project_path" ]; then
    project_name="${project_path##*/}"
fi

if [ -n "$project_name" ] && yq -e ".projects.$project_name" "$CONFIG_FILE" > /dev/null 2>&1; then
    base=".projects.$project_name"
else
    base=".default"
fi

block=$(yq -o=json "$base" "$CONFIG_FILE" 2>/dev/null)
[ -z "$block" ] || [ "$block" = "null" ] && exit 0

case "$mode" in
    project_dirs)
        yq -r '.project_dirs // [] | .[]' "$CONFIG_FILE" 2>/dev/null | sed "s|^~|$HOME|"
        exit 0
        ;;
    windows)
        echo "$block" | jq -r '.windows // [] | .[] | "\(.name)\t\(.command // "")"'
        ;;
    worktree_dir)
        echo "$block" | jq -r '.worktree.dir // empty'
        ;;
    worktree_symlinks)
        echo "$block" | jq -r '.worktree.symlinks // [] | .[]'
        ;;
    worktree_copies)
        echo "$block" | jq -r '.worktree.copies // [] | .[]'
        ;;
    env)
        echo "$block" | jq -r '.env // [] | .[]'
        ;;
    linear)
        echo "$block" | jq -r '.linear // {} | to_entries[] | "\(.key)\t\(.value)"'
        ;;
esac
