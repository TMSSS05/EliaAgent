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

log "=== EliaUI 4-Pane Launcher ==="

# Vérifier que tmux est installé
if ! command -v tmux &>/dev/null; then
    log "ERROR: tmux not found in PATH"
    exit 1
fi

# Créer les dossiers de logs si nécessaire
mkdir -p "$LOG_DIR" 2>/dev/null || true

# Tuer l'ancienne session si elle existe
tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
sleep 0.5

log "Creating new tmux session: $SESSION_NAME"

# Créer la session avec une seule fenêtre
tmux new-session -d -s "$SESSION_NAME" -n "EliaUI"

# Split horizontal (crée pane 1 à droite)
tmux split-window -h -t "$SESSION_NAME:0"
sleep 0.3

# Split vertical dans le pane gauche (crée pane 2 en bas, terminal global)
tmux split-window -v -t "$SESSION_NAME:0.0"
sleep 0.3

# Redimensionner le pane du bas (terminal) pour qu'il soit beaucoup plus petit
tmux resize-pane -t "$SESSION_NAME:0.2" -y 10
sleep 0.3

# Configurer Pane 0 (haut gauche) - OpenCode Server
log "Setting up Pane 0: OpenCode Server (port 4096)"
tmux send-keys -t "$SESSION_NAME:0.0" "bash $SCRIPT_DIR/opencode-serve.sh 4096" Enter

# Configurer Pane 1 (haut droite) - Discord Integration
log "Setting up Pane 1: Discord (start_elias_discord.sh)"
tmux send-keys -t "$SESSION_NAME:0.1" "bash $SCRIPT_DIR/start_elias_discord.sh" Enter

# Configurer Pane 2 (bas, terminal global) - UI Electron
log "Setting up Pane 2: UI (Electron)"
tmux send-keys -t "$SESSION_NAME:0.2" "cd ~/EliaAI/ui_electron && npm start" Enter

# Sélectionner le pane 0 et attacher
log "Attaching to session..."
tmux select-pane -t "$SESSION_NAME:0.0"
exec tmux attach -t "$SESSION_NAME"
