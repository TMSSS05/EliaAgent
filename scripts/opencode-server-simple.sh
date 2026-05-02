#!/bin/zsh
AGENT_DIR="$HOME/EliaAI"
PROXY_CONF="$HOME/.proxychains.conf"
PORT=4096

export PATH="$HOME/.opencode/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

cd "$AGENT_DIR"

if [[ -f "$AGENT_DIR/.proxy_enabled" ]] && [[ -f "$PROXY_CONF" ]]; then
    # Proxy is handled by proxychains4 at library level (no env vars needed)
    log "[PROXY] Proxy mode enabled (proxychains4)"
fi

echo "[SERVER] Starting on port $PORT..."
/Users/vakandi/.opencode/bin/opencode serve --port $PORT &
echo "Server started"