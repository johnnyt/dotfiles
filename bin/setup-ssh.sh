#!/usr/bin/env bash
#
# setup-ssh.sh — ensure an SSH key exists and register it with GitHub + GitLab.
#
# Idempotent. Safe to run standalone:  ~/dotfiles/bin/setup-ssh.sh
#
# - Reuses an existing key (~/.ssh/id_ed25519, else ~/.ssh/id_rsa) if present,
#   otherwise generates a new ed25519 key.
# - Loads it into the agent + Keychain and writes a sane ~/.ssh/config.
# - Copies the public key to the clipboard.
# - Adds it to GitHub/GitLab via gh/glab when authenticated, otherwise opens
#   the right settings page in your browser (key already in clipboard).
set -uo pipefail

info()    { printf '\033[0;34m▸\033[0m %s\n' "$*"; }
success() { printf '\033[0;32m✓\033[0m %s\n' "$*"; }
warn()    { printf '\033[0;33m!\033[0m %s\n' "$*"; }

mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"

# ---------------------------------------------------------------------------
# 1. Find or create a key
# ---------------------------------------------------------------------------
if [ -f "$HOME/.ssh/id_ed25519" ]; then
  KEY="$HOME/.ssh/id_ed25519"
  success "Reusing existing SSH key: $KEY"
elif [ -f "$HOME/.ssh/id_rsa" ]; then
  KEY="$HOME/.ssh/id_rsa"
  success "Reusing existing SSH key: $KEY"
else
  KEY="$HOME/.ssh/id_ed25519"
  info "No SSH key found — generating a new ed25519 key."
  info "Choose a passphrase when prompted (recommended; it'll be saved to Keychain)."
  ssh-keygen -t ed25519 -C "${USER}@$(hostname -s)-$(date +%Y%m%d)" -f "$KEY"
  success "Created $KEY"
fi
PUB="$KEY.pub"

# ---------------------------------------------------------------------------
# 2. ssh-agent + Keychain + ~/.ssh/config
# ---------------------------------------------------------------------------
CONFIG="$HOME/.ssh/config"
if ! grep -qs "AddKeysToAgent" "$CONFIG" 2>/dev/null; then
  cat >> "$CONFIG" <<EOF

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY
EOF
  chmod 600 "$CONFIG"
  success "Wrote agent/Keychain settings to ~/.ssh/config"
fi
eval "$(ssh-agent -s)" >/dev/null 2>&1 || true
ssh-add --apple-use-keychain "$KEY" 2>/dev/null || ssh-add "$KEY" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 3. Clipboard
# ---------------------------------------------------------------------------
pbcopy < "$PUB" && success "Public key copied to clipboard."
TITLE="$(hostname -s)-$(date +%Y%m%d)"

# ---------------------------------------------------------------------------
# 4. GitHub
# ---------------------------------------------------------------------------
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  if gh ssh-key add "$PUB" --title "$TITLE" >/dev/null 2>&1; then
    success "Added SSH key to GitHub (via gh)."
  else
    warn "gh couldn't add the key (may need 'admin:public_key' scope)."
    info "Opening GitHub's key page — paste from clipboard."
    open "https://github.com/settings/ssh/new" 2>/dev/null || true
  fi
else
  info "Opening GitHub's key page — paste from clipboard."
  open "https://github.com/settings/ssh/new" 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 5. GitLab
# ---------------------------------------------------------------------------
if command -v glab >/dev/null 2>&1 && glab auth status >/dev/null 2>&1; then
  if glab ssh-key add "$PUB" --title "$TITLE" >/dev/null 2>&1; then
    success "Added SSH key to GitLab (via glab)."
  else
    warn "glab couldn't add the key."
    info "Opening GitLab's key page — paste from clipboard."
    open "https://gitlab.com/-/user_settings/ssh_keys" 2>/dev/null || true
  fi
else
  info "Opening GitLab's key page — paste from clipboard."
  open "https://gitlab.com/-/user_settings/ssh_keys" 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 6. Verify (optional, non-fatal)
# ---------------------------------------------------------------------------
info "Once the key is added, test with:"
printf '    ssh -T git@github.com\n    ssh -T git@gitlab.com\n'

exit 0
