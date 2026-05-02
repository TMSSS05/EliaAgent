<p align="center">
  <strong>📦 Setup & Installation</strong>
</p>

<p align="center">
  Everything you need to install, configure, and maintain EliaAI on your Mac.
</p>

---

## Quick Install

### macOS (Recommended)

```bash
# 1. Clone
git clone https://github.com/vakandi/EliaAgent.git ~/EliaAI
cd ~/EliaAI

# 2. Run the installer
bash setup/installer.sh

# 3. Start the UI
cd ui_electron && npm install && npm start
```

### Windows

```powershell
# Run the Windows installer
.\setup\installer.bat
```

> The installer handles: dependencies, cron/LaunchAgent setup, proxy config, voice dictation, and desktop shortcuts.

---

## Setup Files Overview

| File | Platform | Purpose |
| :--- | :---: | :--- |
| `installer.sh` | macOS | Full automated install — deps, cron, proxy, voice |
| `installer.bat` | Windows | Windows install script |
| `backup_config.sh` | macOS | Backup all configs, env files, and plists |
| `restore_config.sh` | macOS | Restore from a backup archive |
| `backup_config.bat` | Windows | Windows backup script |
| `restore_config.bat` | Windows | Windows restore script |
| `switch-proxy.sh` | macOS | Proxy rotation with health checks |
| `voice_install.sh` | macOS | Install Whisper + voice dictation deps |
| `speak.sh` | macOS | Text-to-speech via macOS `say` |
| `speak.py` | macOS | Python TTS wrapper |

---

## Installers

### macOS Installer (`installer.sh`)

```bash
bash setup/installer.sh
```

**What it does:**
1. Checks for required tools (`node`, `npm`, `python3`, `brew`)
2. Installs missing dependencies via Homebrew
3. Sets up cron jobs for autonomous runs
4. Configures proxy rotation (`proxychains4`)
5. Installs voice dictation (Whisper)
6. Creates desktop shortcuts
7. Verifies the installation

### Windows Installer (`installer.bat`)

```powershell
.\setup\installer.bat
```

**What it does:**
1. Checks for Python, Node.js, Git
2. Installs pip dependencies
3. Sets up scheduled tasks
4. Configures proxy rotation

---

## Backup & Restore

### Backup Your Config

```bash
# macOS
bash setup/backup_config.sh

# Windows
.\setup\backup_config.bat
```

**Backs up:**
- `.env` files (all integrations)
- `context/` files (business, memory, tools)
- `plists/` (LaunchAgent configs)
- `proxychains.conf`
- `.opencode_model` (selected model)
- Desktop shortcuts

Output: `~/EliaAI_backups/elia_backup_YYYYMMDD_HHMMSS.tar.gz`

### Restore From Backup

```bash
# macOS
bash setup/restore_config.sh ~/EliaAI_backups/elia_backup_20260502_143000.tar.gz

# Windows
.\setup\restore_config.bat "path\to\backup.tar.gz"
```

> Always backup before running the installer or updating the repo.

---

## Proxy Rotation

Automatic proxy switching with health checks and usage tracking.

```bash
# Auto mode — picks the oldest/unused healthy proxy
bash setup/switch-proxy.sh

# Manual mode — shows list, you pick
bash setup/switch-proxy.sh --manual

# Add aliases to ~/.zshrc
echo "alias sp='bash ~/EliaAI/setup/switch-proxy.sh'" >> ~/.zshrc
echo "alias spm='bash ~/EliaAI/setup/switch-proxy.sh --manual'" >> ~/.zshrc
source ~/.zshrc
```

**Proxy file format** (`setup/proxies.txt`):
```
IP:PORT:USERNAME:PASSWORD
```

**How it works:**
1. Reads all proxies from `proxies.txt`
2. Tests each proxy with a health check (`curl` to ipify)
3. Tracks usage history in `proxy_history.json`
4. Selects the oldest unused healthy proxy
5. Updates `~/.proxychains.conf` automatically

---

## Voice Dictation

Install Whisper for local voice-to-text transcription.

```bash
bash setup/voice_install.sh
```

**Installs:**
- `openai-whisper` (large-v3 model)
- `ffmpeg` (audio processing)
- `sox` (audio recording)
- Python dependencies

**Usage:**
```bash
# Record and transcribe
bash setup/speak.sh

# Text-to-speech
bash setup/speak.sh "Hello, this is Elia speaking."
```

---

## Desktop Shortcuts

Pre-built `.app` bundles and shortcuts for quick access:

```
setup/desktop_shortcuts/
├── EliaUI.app          # Launch the Electron UI
├── EliaCron.app        # Manage cron jobs
├── EliaProxy.app       # Switch proxies
└── EliaVoice.app       # Voice dictation
```

Install them to your Applications folder:
```bash
cp -r setup/desktop_shortcuts/*.app /Applications/
```

---

## Agent Setup Prompts

### Setup Tools (`SETUP_TOOLS.md`)

Reference guide for configuring MCP servers, SSH hosts, and external integrations.

### Setup Prompt Agent (`SETUP_PROMPT_AGENT.md`)

Prompt template for using an AI agent to auto-configure EliaAI with your personal info:

```
Set up EliaAI for myself. Update all context/ files, PROMPT.md,
MORNING_PROMPT.md, and subagent personalities with MY information.
Replace all references with my name, my businesses, and my team.
Keep the same structure.
```

### Sync Prompt (`SYNC_PROMPT.md`)

Guide for syncing the private `EliaAI` repo to the public `EliaAgent` repo:
- Sanitization checklist (secrets, private names, tokens)
- File-by-file diff analysis
- Commit strategy for clean public history

---

## Subworkers System (`SUBWORKERS_SYSTEM.md`)

Documentation for the promoter agent system:
- How promoter templates work
- LaunchAgent plist configuration
- Trigger scripts for automated promotion
- Scheduling and rotation logic

---

## Security & MCP (`mcp_security_report.md`)

Security audit report for MCP server configurations:
- SSH blacklist rules (protected commands)
- MCP server access controls
- Token rotation recommendations
- Vulnerability assessment

---

## Brain Relinking (`RELINK_BRAIN.md`)

Guide for reconnecting the `brain/` module after repo moves or renames:
- Update symlinks
- Fix import paths
- Rebuild context references

---

## Release Notes (`RELEASENOTES.md`)

Detailed changelog for each version:
- New features
- Bug fixes
- Breaking changes
- Migration steps

---

## Improv Cron Prompt (`improv_cron_prompt.md`)

Template for improving cron job configurations:
- Adjusting intervals
- Adding time windows
- Error handling improvements
- Logging enhancements

---

## Troubleshooting

| Issue | Fix |
| :--- | :--- |
| Installer fails on `brew` | Run `xcode-select --install` first |
| Proxy not switching | Check `proxies.txt` format — must be `IP:PORT:USER:PASS` |
| Voice not recording | Run `voice_install.sh` and check microphone permissions |
| Backup fails | Ensure no files are locked by running processes |
| Desktop shortcuts don't launch | Check `EliaUI.app/Contents/Info.plist` paths |
| Windows installer hangs | Run as Administrator, disable antivirus temporarily |

---

<p align="center">
  <strong>EliaAI Setup</strong> — Install. Configure. Run.
</p>
