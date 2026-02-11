#!/bin/bash
STATE_FILE="/tmp/claude-agents-state.json"

NOW=$(date +%s)
jq -r --argjson now "$NOW" '.sessions | to_entries[] |
    (.value.last_changed // $now) as $lc |
    (($now - $lc) | if . < 60 then "\(.)s"
     elif . < 3600 then "\(. / 60 | floor)m"
     elif . < 86400 then "\(. / 3600 | floor)h"
     else "\(. / 86400 | floor)d" end) as $ago |
    (.value.pane_title | if length > 40 then .[:37] + "..." else . end) as $pane |
    if .value.state == "confirmation" then
        "\(.key)|\(.value.pane_id)|\(.value.window_id)|\(.value.session_name)|confirmation\t  \u001b[33m⚠\u001b[0m \($ago) ago - \($pane) [\u001b[33m\(.value.session_name):\(.value.window_name)\u001b[0m]"
    elif .value.state == "idle" then
        "\(.key)|\(.value.pane_id)|\(.value.window_id)|\(.value.session_name)|idle\t  \u001b[32m✓\u001b[0m \($ago) ago - \u001b[90m\($pane) [\(.value.session_name):\(.value.window_name)]\u001b[0m"
    else
        "\(.key)|\(.value.pane_id)|\(.value.window_id)|\(.value.session_name)|running\t  \u001b[36m⟳\u001b[0m \($ago) ago - \($pane) [\u001b[33m\(.value.session_name):\(.value.window_name)\u001b[0m]"
    end' "$STATE_FILE"
