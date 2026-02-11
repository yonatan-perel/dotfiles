#!/bin/bash
# Rescan sessions then format for fzf. Used by reload after toggle.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
bash "$SCRIPT_DIR/scan-sessions.sh"
bash "$SCRIPT_DIR/format-popup-list.sh"
