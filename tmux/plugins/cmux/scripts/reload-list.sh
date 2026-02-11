#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
bash "$SCRIPT_DIR/scan-sessions.sh"
bash "$SCRIPT_DIR/unified-list.sh" "$1"
