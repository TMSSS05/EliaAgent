#!/bin/zsh
# Start EliaAI Discord bot

set -euo pipefail

AGENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BOT_DIR="${AGENT_DIR}/integrations/elia-discord-bot"

# Proxy is handled by proxychains4 at library level (no env vars needed)
# The bot.py handles proxy via proxychains4 if .proxy_enabled exists

if [[ ! -d "$BOT_DIR" ]]; then
    echo "elia-discord-bot not found at: $BOT_DIR"
    exit 1
fi

for env in "${BOT_DIR}/.env" "${AGENT_DIR}/.env"; do
    if [[ -f "$env" ]]; then
        cd "$BOT_DIR"
        
        if [[ ! -d "venv" ]]; then
            echo "Creating venv..."
            python3 -m venv venv
        fi
        
        source venv/bin/activate
        
        if ! python -c "import discord" 2>/dev/null; then
            echo "Installing dependencies..."
            pip install -r requirements.txt
        fi
        
        unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
        
        echo "Starting EliaDiscord bot..."
        mkdir -p "${BOT_DIR}/logs"
        python bot.py
        exit 0
    fi
done

echo "No .env found."
exit 1