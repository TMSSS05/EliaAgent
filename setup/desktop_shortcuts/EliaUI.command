#!/bin/zsh
set -euo pipefail
IFS=$'\n\t'

# Configuration
SCRIPT_DIR="$HOME/EliaAI/scripts"
LOG_DIR="$HOME/EliaAI/logs"
SESSION_NAME="elia"

log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [EliaUI] $*" >&2
}

log "=== EliaUI 4-Window Tmux Launcher ==="

# Check tmux is installed
if ! command -v tmux &>/dev/null; then
    log "ERROR: tmux not found in PATH"
    exit 1
fi

# Create log directory if needed
mkdir -p "$LOG_DIR" 2>/dev/null || true

# Kill existing session if present
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
sleep 0.5

log "Creating new tmux session: $SESSION_NAME"

# Create the session with first window (OpenCode server)
tmux new-session -d -s "$SESSION_NAME" -n "Elia-1" 2>/dev/null || {
    log "ERROR: Failed to create tmux session"
    exit 1
}
sleep 0.3

# Window 1: OpenCode server (port 4096)
log "Setting up Window 1: OpenCode Server (port 4096)"
tmux send-keys -t "$SESSION_NAME:0" "bash $SCRIPT_DIR/opencode-serve.sh 4096" Enter
sleep 0.3

# Window 2: CodeMem Viewer
log "Setting up Window 2: CodeMem Viewer"
tmux new-window -t "$SESSION_NAME" -n "Elia-2" 2>/dev/null || true
sleep 0.3
tmux send-keys -t "$SESSION_NAME:1" "bash $SCRIPT_DIR/codemem-viewer.sh" Enter
sleep 0.3

# Window 3: Agents
log "Setting up Window 3: Agents"
tmux new-window -t "$SESSION_NAME" -n "Elia-3" 2>/dev/null || true
sleep 0.3
tmux send-keys -t "$SESSION_NAME:2" "bash $SCRIPT_DIR/start_agents.sh" Enter
sleep 0.3

# Window 4: UI (elia-ui.sh)
log "Setting up Window 4: UI"
tmux new-window -t "$SESSION_NAME" -n "Elia-4" 2>/dev/null || true
sleep 0.3
tmux send-keys -t "$SESSION_NAME:3" "bash $SCRIPT_DIR/elia-ui.sh" Enter
sleep 0.3

# Select window 1 and attach
log "Attaching to session..."
tmux select-window -t "$SESSION_NAME:0"
exec tmux attach -t "$SESSION_NAME"
