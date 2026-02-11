#!/bin/bash
# Show popup with running agents

STATE_FILE="/tmp/claude-agents-state.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Get all agents (running + completed), numbered sequentially
ALL_AGENTS=""
if [ -f "$STATE_FILE" ]; then
    ALL_AGENTS=$(jq -r '.agents | to_entries[] |
        "\(.key + 1)|\(.value.status)|\(.value.type)|\(.value.description)"' "$STATE_FILE" 2>/dev/null)
fi

# Build output
OUTPUT="╭─ Claude Code Agents ─────────────────────────────────╮\n"
OUTPUT+="│                                                      │\n"

if [ -z "$ALL_AGENTS" ]; then
    OUTPUT+="│  No agents found                                     │\n"
else
    RUNNING_SECTION=""
    COMPLETED_SECTION=""

    while IFS='|' read -r num status type desc; do
        # Truncate description to fit
        DESC_SHORT=$(echo "$desc" | cut -c 1-30)

        if [ "$status" = "running" ]; then
            LINE=$(printf "%s. 🏃 [%s] %s" "$num" "$type" "$DESC_SHORT")
            LINE_TEXT=$(echo "$LINE" | cut -c 1-50)
            printf -v PADDED_LINE "│  %-52s│\n" "$LINE_TEXT"
            RUNNING_SECTION+="$PADDED_LINE"
        elif [ "$status" = "completed" ]; then
            LINE=$(printf "%s. ✓ [%s] %s" "$num" "$type" "$DESC_SHORT")
            LINE_TEXT=$(echo "$LINE" | cut -c 1-50)
            printf -v PADDED_LINE "│  %-52s│\n" "$LINE_TEXT"
            COMPLETED_SECTION+="$PADDED_LINE"
        fi
    done <<< "$ALL_AGENTS"

    if [ -n "$RUNNING_SECTION" ]; then
        OUTPUT+="│  🏃 Running:                                          │\n"
        OUTPUT+="│                                                      │\n"
        OUTPUT+="$RUNNING_SECTION"
    fi

    if [ -n "$COMPLETED_SECTION" ]; then
        OUTPUT+="│                                                      │\n"
        OUTPUT+="│  ✓ Completed:                                        │\n"
        OUTPUT+="│                                                      │\n"
        OUTPUT+="$COMPLETED_SECTION"
    fi
fi

OUTPUT+="│                                                      │\n"
OUTPUT+="│  Press 1-9 to jump to agent pane                     │\n"
OUTPUT+="│  Press q or Esc to close                             │\n"
OUTPUT+="╰──────────────────────────────────────────────────────╯"

# Show popup
echo -e "$OUTPUT"

# Wait for input
read -rsn1 input

# Handle numeric input (jump to agent)
if [[ "$input" =~ ^[1-9]$ ]]; then
    bash "$SCRIPT_DIR/jump-to-agent.sh" "$input"
fi
