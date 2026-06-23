#!/usr/bin/env bash
#
# install.sh — set up a fresh macOS machine.
#
# Safe to run repeatedly (idempotent). Run it like:
#
#   git clone https://github.com/johnnyt/dotfiles ~/dotfiles && ~/dotfiles/install.sh
#
# Or one-shot from a fresh machine:
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/johnnyt/dotfiles/main/install.sh)"
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_MACOS="${SKIP_MACOS:-0}"

# ---------------------------------------------------------------------------
# pretty output
# ---------------------------------------------------------------------------
info()    { printf '\033[0;34m▸\033[0m %s\n' "$*"; }
success() { printf '\033[0;32m✓\033[0m %s\n' "$*"; }
warn()    { printf '\033[0;33m!\033[0m %s\n' "$*"; }

# Ensure the Xcode Command Line Tools (git, clang, make, ...) are present.
# `command -v git` is unreliable on a fresh Mac — /usr/bin/git is a stub that
# only triggers the installer — so detect via xcode-select -p, and BLOCK until
# the (GUI) installer actually finishes before returning.
ensure_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    return 0
  fi
  info "Installing Xcode Command Line Tools — accept the dialog that appears..."
  xcode-select --install >/dev/null 2>&1 || true
  until xcode-select -p >/dev/null 2>&1; do
    printf '  …waiting for Command Line Tools to finish installing\n'
    sleep 20
  done
  success "Xcode Command Line Tools installed."
}

# ---------------------------------------------------------------------------
# bootstrap: this script may be curl-piped before the repo exists on disk.
# If so, clone it and re-exec from the cloned copy.
# ---------------------------------------------------------------------------
REPO_URL="https://github.com/johnnyt/dotfiles"
TARGET="$HOME/dotfiles"
if [ ! -f "$DOTFILES/Brewfile" ]; then
  ensure_clt   # need a working git before we can clone
  info "Cloning dotfiles to $TARGET ..."
  git clone "$REPO_URL" "$TARGET"
  exec "$TARGET/install.sh"
fi

# ---------------------------------------------------------------------------
# 1. Xcode command line tools (git, clang, make, ...)
# ---------------------------------------------------------------------------
ensure_clt

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Put brew on PATH for the rest of this run (Apple Silicon path).
eval "$(/opt/homebrew/bin/brew shellenv)"
success "Homebrew ready."

# ---------------------------------------------------------------------------
# 3. Packages — everything lives in the Brewfile (formulae, casks, VS Code exts)
# ---------------------------------------------------------------------------
info "Installing packages from Brewfile (this can take a while)..."
brew bundle --file="$DOTFILES/Brewfile"
success "Packages installed."

# ---------------------------------------------------------------------------
# 4. Symlink dotfiles into place
# ---------------------------------------------------------------------------
link() {  # link <source-in-repo> <target-in-home>
  local src="$DOTFILES/$1" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] || [ -e "$dst" ]; then
    # Back up anything real that isn't already our symlink.
    if [ "$(readlink "$dst" 2>/dev/null)" != "$src" ]; then
      mv "$dst" "$dst.backup.$(date +%s)"
      warn "Backed up existing $dst"
    fi
  fi
  ln -sfn "$src" "$dst"
  success "linked ~/$2"
}

seed() {  # seed <source-in-repo> <target-in-home> — copy only if target is missing
  local src="$DOTFILES/$1" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ]; then
    info "kept existing ~/$2"
  else
    cp "$src" "$dst"
    success "seeded ~/$2"
  fi
}

info "Linking dotfiles..."
link git/gitconfig          .gitconfig
link git/gitignore_global   .gitignore_global
link mise/config.toml       .config/mise/config.toml
link starship/starship.toml .config/starship.toml
link ghostty/config         .config/ghostty/config
link aerospace/aerospace.toml .config/aerospace/aerospace.toml
link tmux/tmux.conf         .tmux.conf
link fish/config.fish       .config/fish/config.fish
link fish/fish_plugins      .config/fish/fish_plugins
link fish/functions         .config/fish/functions
link nvim                   .config/nvim
link vscode/settings.json   "Library/Application Support/Code/User/settings.json"

# Claude Code — hand-curated config + memory are symlinked (tracked live).
link claude/CLAUDE.md           .claude/CLAUDE.md
link claude/settings.json       .claude/settings.json
link claude/settings.local.json .claude/settings.local.json
# Memory lives under the cwd-derived project dir; assumes username 'johnnyt'.
link claude/memory              ".claude/projects/-Users-${USER}/memory"
# Plugin manifests carry machine-specific install paths/timestamps that Claude
# Code rewrites, so seed them (copy-if-missing) rather than symlink.
seed claude/plugins/installed_plugins.json  .claude/plugins/installed_plugins.json
seed claude/plugins/known_marketplaces.json .claude/plugins/known_marketplaces.json
seed claude/plugins/config.json             .claude/plugins/config.json

# Per-machine git identity (name/email) — not tracked, edit after install.
if [ ! -f "$HOME/.gitconfig.local" ]; then
  cp "$DOTFILES/git/gitconfig.local.example" "$HOME/.gitconfig.local"
  warn "Created ~/.gitconfig.local — edit it with this machine's name/email."
fi

# ---------------------------------------------------------------------------
# 5. mise — install the global language toolchains
# ---------------------------------------------------------------------------
if command -v mise >/dev/null 2>&1; then
  info "Installing language runtimes via mise..."
  mise install
  success "mise toolchains installed."
fi

# ---------------------------------------------------------------------------
# 6. SSH key — create if missing, register with GitHub + GitLab
# ---------------------------------------------------------------------------
info "Setting up SSH key..."
bash "$DOTFILES/bin/setup-ssh.sh" || warn "SSH setup had issues — re-run bin/setup-ssh.sh"

# ---------------------------------------------------------------------------
# 7. fish — set as default shell + install plugins (fisher)
# ---------------------------------------------------------------------------
FISH_BIN="$(command -v fish || true)"
if [ -n "$FISH_BIN" ]; then
  if ! grep -q "$FISH_BIN" /etc/shells; then
    echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null
  fi
  if [ "$SHELL" != "$FISH_BIN" ]; then
    info "Setting fish as the default shell..."
    chsh -s "$FISH_BIN"
  fi
  info "Installing fish plugins (fisher)..."
  "$FISH_BIN" -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update" || \
    warn "fisher install skipped — run 'fisher update' inside fish later."
fi

# ---------------------------------------------------------------------------
# 8. macOS defaults
# ---------------------------------------------------------------------------
if [ "$SKIP_MACOS" != "1" ]; then
  info "Applying macOS defaults..."
  bash "$DOTFILES/macos/defaults.sh"
fi

success "Done. Open a new terminal (or log out/in) for everything to take effect."
