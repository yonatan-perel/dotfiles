# Claude Code Sessions tmux Plugin

Monitor and jump between all Claude Code sessions in your tmux environment.

## Features

- **Status Bar Indicator**: Shows Claude Code session count (e.g., "🤖 2") in your tmux status bar
- **Popup Dashboard**: Press `prefix + a` to see all Claude Code sessions
- **Quick Jump**: Press 1-9 in the popup to jump to any Claude Code session
- **Auto-Discovery**: Automatically scans tmux every 5 seconds for Claude Code sessions
- **Refresh on Demand**: Press 'r' in the popup to force an immediate refresh

## Installation

Already installed! The plugin is configured in your tmux.conf and Claude Code settings.

## Usage

### View All Claude Code Sessions
Press `Ctrl-a` (your prefix) followed by `a` to open the sessions dashboard popup.

The popup shows:
- All Claude Code sessions currently running in tmux
- Project name and session/window information
- Numbered list for quick jumping (1-9)

### Jump to Session
While the popup is open, press a number key (1-9) to jump to that session's pane.

### Refresh
Press `r` in the popup to force an immediate scan for new sessions.

### Status Bar
The status bar automatically shows the count of Claude Code sessions. Updates every 5 seconds.

## How It Works

1. **Periodic Scanning**: Every 5 seconds, scans all tmux panes for Claude Code processes
2. **State Tracking**: Stores session info in `/tmp/claude-agents-state.json`
3. **Status Bar**: Displays the count of active Claude Code sessions
4. **Popup**: Shows detailed list when you press `prefix + a`, with fresh scan
5. **Jump**: Switches to the selected tmux pane/window/session

## Files

- `claude-agents.tmux` - Main plugin loader
- `scripts/scan-sessions.sh` - Scans tmux for Claude Code sessions
- `scripts/status-bar-sessions.sh` - Displays session count in status bar
- `scripts/popup-sessions.sh` - Shows detailed session dashboard with jump functionality

## State File

Session state is stored in `/tmp/claude-agents-state.json`:
```json
{
  "sessions": [
    {
      "session_name": "myproject",
      "window_id": "@1",
      "window_name": "agent",
      "pane_id": "%1",
      "pane_title": "✳ Task Description",
      "project": "myproject",
      "path": "/Users/you/Code/myproject"
    }
  ],
  "updated_at": "2026-02-11T10:00:00Z"
}
```

## Troubleshooting

If the plugin isn't working:
1. Verify scripts are executable: `ls -l ~/.config/tmux/plugins/claude-agents/scripts/`
2. Manual scan: `bash ~/.config/tmux/plugins/claude-agents/scripts/scan-sessions.sh`
3. Check state file: `cat /tmp/claude-agents-state.json | jq .`
4. Check status bar: `bash ~/.config/tmux/plugins/claude-agents/scripts/status-bar-sessions.sh`
5. Reload tmux: `prefix + r`

## Customization

### Change Keybinding
Edit `~/.config/tmux/tmux.conf`:
```tmux
# Change from 'a' to something else
set -g @plugin 'claude-agents'
bind-key A display-popup -E -w 60 -h 20 "bash ~/.config/tmux/plugins/claude-agents/scripts/popup.sh"
```

### Change Status Bar Format
Edit `scripts/status-bar.sh` to customize the indicator appearance.

### Change Scan Interval
Edit `claude-agents.tmux` and change `status-interval` value (default: 5 seconds).
