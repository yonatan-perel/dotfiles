#!/usr/bin/env bash

CONFIG_FILE="${CMUX_CONFIG:-$HOME/.config/cmux/cmux.toml}"

if [ ! -f "$CONFIG_FILE" ]; then
    exit 0
fi

mode="$1"

case "$mode" in
    project_dirs)
        while IFS= read -r line; do
            line="${line%%#*}"
            line="${line#"${line%%[![:space:]]*}"}"
            line="${line%"${line##*[![:space:]]}"}"
            [[ "$line" != project_dirs* ]] && continue
            val="${line#*=}"
            val="${val#"${val%%[![:space:]]*}"}"
            val="${val#\[}"
            val="${val%\]}"
            IFS=',' read -ra items <<< "$val"
            for item in "${items[@]}"; do
                item="${item#"${item%%[![:space:]]*}"}"
                item="${item%"${item##*[![:space:]]}"}"
                item="${item#\"}"
                item="${item%\"}"
                item="${item/#\~/$HOME}"
                [ -n "$item" ] && echo "$item"
            done
        done < "$CONFIG_FILE"
        ;;
    windows)
        in_window=false
        name=""
        command=""
        while IFS= read -r line; do
            line="${line%%#*}"
            line="${line#"${line%%[![:space:]]*}"}"
            line="${line%"${line##*[![:space:]]}"}"
            [ -z "$line" ] && continue
            if [[ "$line" == "[[windows]]" ]]; then
                if [ "$in_window" = true ] && [ -n "$name" ]; then
                    printf '%s\t%s\n' "$name" "$command"
                fi
                in_window=true
                name=""
                command=""
                continue
            fi
            if [ "$in_window" = true ]; then
                if [[ "$line" == "["* ]]; then
                    if [ -n "$name" ]; then
                        printf '%s\t%s\n' "$name" "$command"
                    fi
                    in_window=false
                    name=""
                    command=""
                    continue
                fi
                key="${line%%=*}"
                key="${key%"${key##*[![:space:]]}"}"
                val="${line#*=}"
                val="${val#"${val%%[![:space:]]*}"}"
                val="${val#\"}"
                val="${val%\"}"
                case "$key" in
                    name) name="$val" ;;
                    command) command="$val" ;;
                esac
            fi
        done < "$CONFIG_FILE"
        if [ "$in_window" = true ] && [ -n "$name" ]; then
            printf '%s\t%s\n' "$name" "$command"
        fi
        ;;
esac
