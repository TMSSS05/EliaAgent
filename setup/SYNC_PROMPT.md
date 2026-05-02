# EliaAI → EliaAgent Sync Prompt

> Use this prompt when you want to sync your private EliaAI repo to the public EliaAgent repo.

---

## Context

You are working with TWO GitHub repos:
- **Private**: `/Users/vakandi/EliaAI` (your working repo with all your changes)
- **Public**: `/Users/vakandi/EliaAgent` (cleaned repo for public release)

Your task is to SYNC the private repo to the public repo, cleaning all sensitive data (credentials, logs, personal info) while preserving all functionality.

---

## Mission

1. **COMPARE** the two repos to find all differences
2. **IDENTIFY** what needs to be copied (new files) or updated (modified files)
3. **FILTER** out sensitive data that should NOT be copied:
   - `.env` files with real credentials
   - `logs/` directories
   - `docs/YYYY-MM-DD/` daily log folders
   - `brain/obsidian/` private wiki
   - `memory/*-CREDENTIALS.md` secret files
   - `node_modules/` (will be rebuilt)
   - `__pycache__/`, `venv/` Python caches
   - `.sisyphus/` runtime state
   - `store/` Electron user data
4. **COPY** clean files from EliaAI → EliaAgent
5. **UPDATE** documentation:
   - `setup/README.md` with any new features
   - `RELEASENOTES.md` with changelog
6. **COMMIT** with clear message
7. **PUSH** to GitHub
8. **UPDATE** the GitHub release

---

## Step-by-Step Instructions

### Step 1: Compare Repos

Run this to find differences:
```bash
diff -rq /Users/vakandi/EliaAI /Users/vakandi/EliaAgent --exclude=".git" --exclude="*.log" 2>/dev/null | head -100
```

Or use explore agent for deeper analysis.

### Step 2: Identify What to Copy

**Typically NEW in EliaAI (copy to EliaAgent):**
- `setup/desktop_shortcuts/` - Desktop shortcuts
- `integrations/elia-discord-bot/` - Discord bot
- `subworkers/` - Subworker agents
- New scripts in `scripts/`
- Updated `ui_electron/` (without node_modules)

**Typically MODIFIED (check diff):**
- `setup/README.md` - Setup docs
- `PROMPT.md` - Main prompt
- `context/TOOLS.md` - Tools reference
- `context/business.md` - Business info

**NEVER Copy:**
- `.env` - Real credentials
- `logs/` - Runtime logs
- `docs/YYYY-MM-DD/` - Daily logs
- `brain/obsidian/` - Private wiki
- `memory/*-CREDENTIALS.md` - Secrets
- `node_modules/` - NPM packages
- `venv/`, `__pycache__/` - Python caches

### Step 3: Clean Sensitive Data

Before copying, clean the source:
```bash
# Clean EliaAI integrations before copy
rm -rf /Users/vakandi/EliaAI/integrations/elia-discord-bot/.env
rm -rf /Users/vakandi/EliaAI/integrations/elia-discord-bot/__pycache__
rm -rf /Users/vakandi/EliaAI/integrations/elia-discord-bot/venv
rm -rf /Users/vakandi/EliaAI/integrations/elia-discord-bot/logs
rm -rf /Users/vakandi/EliaAI/integrations/elia-discord-bot/sessions.json
rm -rf /Users/vakandi/EliaAI/ui_electron/node_modules
rm -rf /Users/vakandi/EliaAI/ui_electron/.sisyphus
rm -rf /Users/vakandi/EliaAI/ui_electron/store
rm -rf /Users/vakandi/EliaAI/ui_electron/.jarvis-position.json
```

### Step 4: Copy Files

```bash
# Copy desktop shortcuts
cp -R /Users/vakandi/EliaAI/setup/desktop_shortcuts/* /Users/vakandi/EliaAgent/setup/desktop_shortcuts/

# Copy discord bot (clean)
cp -R /Users/vakandi/EliaAI/integrations/elia-discord-bot /Users/vakandi/EliaAgent/integrations/

# Copy ui_electron (without node_modules)
rm -rf /Users/vakandi/EliaAgent/ui_electron
cp -R /Users/vakandi/EliaAI/ui_electron /Users/vakandi/EliaAgent/ui_electron

# Clean any remaining private data in target
rm -rf /Users/vakandi/EliaAgent/ui_electron/.jarvis-position.json
rm -rf /Users/vakandi/EliaAgent/ui_electron/.sisyphus
rm -rf /Users/vakandi/EliaAgent/ui_electron/store
```

### Step 5: Update Documentation

Add new features to `RELEASENOTES.md`:
```markdown
## Version: vX.X.X (DATE)

### New Features
- [Feature 1] - Description
- [Feature 2] - Description

### Bug Fixes
- [Fix 1] - Description
```

Update `setup/README.md` if needed with new sections.

### Step 6: Commit

```bash
cd /Users/vakandi/EliaAgent
git add -A
git status  # Verify only intended files
git commit -m "feat: add [feature 1], [feature 2], [feature 3]"
```

### Step 7: Push

```bash
git push origin main
```

### Step 8: Update Release

```bash
gh release edit v1.0.0 --notes-file RELEASENOTES.md
# Or create new release:
gh release create "vX.X.X" --title "EliaAI vX.X.X" --notes-file RELEASENOTES.md --target main
```

---

## Quick Copy-Paste Prompts

### For Explore Agent:
```
Compare /Users/vakandi/EliaAI vs /Users/vakandi/EliaAgent

List ALL differences:
- New files in EliaAI (need copy)
- Modified files (need update)
- Files that should NOT be copied (sensitive)

Focus on: setup/, ui_electron/, integrations/, subworkers/
```

### For Execution:
```
Sync EliaAI to EliaAgent:
1. Clean sensitive data from source
2. Copy new/modified files
3. Update RELEASENOTES.md
4. Commit and push
5. Update GitHub release

Use /Users/vakandi/EliaAI as source, /Users/vakandi/EliaAgent as target.
```

---

## Common Files to Check

| Path | Copy? | Notes |
|------|--------|-------|
| `setup/desktop_shortcuts/*` | YES | Desktop shortcuts |
| `integrations/elia-discord-bot/` | YES | Discord bot (clean .env first) |
| `ui_electron/*` | YES | UI (exclude node_modules) |
| `subworkers/*` | YES | Subworker agents |
| `context/TOOLS.md` | YES (cleaned) | Remove real tokens |
| `context/business.md` | YES (cleaned) | Replace with placeholders |
| `PROMPT.md` | YES | Main prompt |
| `setup/README.md` | YES | Update with new features |
| `RELEASENOTES.md` | YES | Add changelog |
| `.env` | NO | Never copy |
| `logs/*` | NO | Never copy |
| `docs/YYYY-MM-DD/*` | NO | Never copy |
| `brain/obsidian/*` | NO | Never copy |
| `memory/*-CREDENTIALS.md` | NO | Never copy |

---

## Automated Script (Optional)

Create a sync script:
```bash
#!/bin/bash
# EliaAI → EliaAgent Sync Script

SOURCE="/Users/vakandi/EliaAI"
TARGET="/Users/vakandi/EliaAgent"

echo "🔄 Syncing EliaAI → EliaAgent"

# Clean sensitive data from source
echo "🧹 Cleaning sensitive data..."
rm -rf "$SOURCE/integrations/elia-discord-bot/.env"
rm -rf "$SOURCE/integrations/elia-discord-bot/__pycache__"
rm -rf "$SOURCE/integrations/elia-discord-bot/venv"
rm -rf "$SOURCE/integrations/elia-discord-bot/logs"
rm -rf "$SOURCE/integrations/elia-discord-bot/sessions.json"
rm -rf "$SOURCE/ui_electron/node_modules"
rm -rf "$SOURCE/ui_electron/.sisyphus"
rm -rf "$SOURCE/ui_electron/store"
rm -rf "$SOURCE/ui_electron/.jarvis-position.json"

# Copy directories
echo "📦 Copying files..."
cp -R "$SOURCE/setup/desktop_shortcuts" "$TARGET/setup/"
cp -R "$SOURCE/integrations/elia-discord-bot" "$TARGET/integrations/"

# Copy ui_electron (replace)
rm -rf "$TARGET/ui_electron"
cp -R "$SOURCE/ui_electron" "$TARGET/ui_electron"

# Clean target
rm -rf "$TARGET/ui_electron/.sisyphus"
rm -rf "$TARGET/ui_electron/store"
rm -rf "$TARGET/ui_electron/.jarvis-position.json"

echo "✅ Sync complete!"
echo "Run: cd $TARGET && git status"
```

---

## Notes

- Always verify `.gitignore` covers sensitive files
- Check for Discord bot tokens in TOOLS.md before commit
- Use `gh release edit` to update existing release or `gh release create` for new
- Run `git status` before commit to verify only intended files

---

## ⚠️ CRITICAL: Sanitization Checklist (BEFORE every push)

**These rules were learned the hard way. NEVER skip them.**

### 1. Working Tree Scan (before commit)

```bash
# Scan for hardcoded secrets in current files
grep -rn "API_KEY\s*=\s*['\"][A-Za-z0-9]{20,}" --include="*.py" --include="*.js" --include="*.ts" --include="*.sh" .
grep -rn "DISCORD_BOT_TOKEN\s*=\s*['\"][A-Za-z0-9]{20,}" --include="*.py" --include="*.env*" .
grep -rn "password\s*=\s*['\"][^'\"]{8,}" --include="*.py" --include="*.js" .
grep -rn "Bearer\s*ey" --include="*.py" --include="*.js" --include="*.ts" .
```

**If found**: Replace with `os.environ.get("VAR_NAME", "YOUR_PLACEHOLDER_HERE")` or `.env.example` with placeholder values.

### 2. History Scan (before push)

```bash
# Check ALL history for secrets
git log --all -p | grep -c "MTQ2NDI3NzcyNzQ4NDg0MjAzNQ"  # Discord tokens
git log --all -p | grep -c "eyJ0eXAiOiJKV1Qi"              # JWT tokens
git log --all -p | grep -iE "(password|secret|token|api_key)\s*=\s*['\"][A-Za-z0-9]{10,}" | grep -v "YOUR_\|placeholder\|example\|os\.environ"
```

**If count > 0**: You MUST rewrite history before pushing.

### 3. History Rewrite (if secrets found)

```bash
# Replace Discord token in all history
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch --force --tree-filter '
if [ -f "integrations/elia-discord-bot/.env.example" ]; then
  sed -i "" "s/MTQ2NDI3NzcyNzQ4NDg0MjAzNQ\.GUUEis\.[A-Za-z0-9_-]*/YOUR_DISCORD_BOT_TOKEN_HERE/g" "integrations/elia-discord-bot/.env.example"
fi
' --tag-name-filter cat -- --all

# Replace CloudConvert JWT in all history
FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch --force --tree-filter '
if [ -f "tools/cloudconvert_md_to_docx.py" ]; then
  sed -i "" "s/eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9\.[A-Za-z0-9._-]*/YOUR_CLOUDCONVERT_API_KEY_HERE/g" "tools/cloudconvert_md_to_docx.py"
fi
' --tag-name-filter cat -- --all

# Clean up old refs
git for-each-ref --format='%(refname)' refs/original/ | while read ref; do git update-ref -d "$ref"; done
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### 4. Private Company Names — MUST Rename

**Before pushing to public repo, rename ALL company-specific names:**

| Private Name | Public Replacement |
|---|---|
| `bene2luxe-promoter/` | `promoter-template-1/` |
| `cobou-promoter/` | `promoter-template-2/` |
| `Bene2Luxe` (in code/docs) | `LuxuryBrand` or `[Your Brand]` |
| `CoBou Agency` | `DigitalAgency` or `[Your Agency]` |
| `ZovaBoost` | `SMMPanel` or `[Your Panel]` |
| `Mayavanta` | `PartnershipPlatform` or `[Your Platform]` |
| `OGBoujee` | `LuxuryBags` or `[Your Brand]` |
| Personal email addresses | `contact@yourdomain.com` |
| WhatsApp group JIDs | `YOUR_GROUP_JID` |
| Server IPs | `YOUR_SERVER_IP` |

### 5. Files That Commonly Contain Secrets

| File | Risk | Action |
|---|---|---|
| `.env`, `.env.example` | HIGH | Never commit real values, use placeholders |
| `TOOLS.md` | HIGH | Contains MCP tokens, SSH hosts, JIDs |
| `context/business.md` | HIGH | Contains real names, emails, businesses |
| `context/MEMORY.md` | HIGH | Contains personal info, team contacts |
| `context/TOOLS.md` | HIGH | Contains real API keys, server IPs |
| `*.py` with `API_KEY = "..."` | HIGH | Replace with `os.environ.get()` |
| `*.js`/`*.ts` with `token: "..."` | HIGH | Replace with `process.env` |
| `integrations/*/.env*` | HIGH | Always use `.env.example` with placeholders |
| `tools/*.py` | MEDIUM | Check for hardcoded credentials |

### 6. Push Verification

```bash
# After all sanitization, final check before push
echo "=== Final Secret Scan ==="
git log --all -p | grep -iE "(password|secret|token|api_key)\s*=\s*['\"][A-Za-z0-9]{10,}" | grep -v "YOUR_\|placeholder\|example\|empty\|changeme\|TODO\|os\.environ" | wc -l
# Should output: 0

# If > 0, DO NOT PUSH. Rewrite history first.
```

---

## Lessons Learned (May 2026)

1. **GitHub Secret Scanning is aggressive** — it scans ALL commits in history, not just the latest. A single leaked token in any past commit will block the push.
2. **`git filter-branch` requires clean working tree** — commit your fixes first, then rewrite history.
3. **Always clean old refs after filter-branch** — `refs/original/` keeps the dirty commits alive.
4. **Promoter folder names are private** — `bene2luxe-promoter` and `cobou-promoter` reveal company names. Use generic `promoter-template-*` naming.
5. **Hardcoded JWT tokens in Python scripts** — `tools/cloudconvert_md_to_docx.py` had a live API key. Always use `os.environ.get()`.
6. **Discord bot tokens in `.env.example`** — even example files with real tokens are dangerous. Use `YOUR_DISCORD_BOT_TOKEN_HERE`.

---

**Last updated**: May 2026
