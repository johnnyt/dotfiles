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

# When curl-piped (bash -c "$(curl ...)" or curl | bash) the script has no
# source file, so BASH_SOURCE is unset — fall back to $0 to avoid tripping
# `set -u`. DOTFILES is bogus in that case, but the bootstrap block below
# detects the missing repo, clones it, and re-execs from the real file.
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
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
# Detect brew by its on-disk location, not just $PATH. A brand-new user account
# on a Mac that already has Homebrew won't have /opt/homebrew/bin on PATH yet
# (that's wired up by `brew shellenv` in the shell rc, which a fresh login
# hasn't sourced). Relying on `command -v brew` would wrongly conclude Homebrew
# is missing and re-run the installer — which, finding an existing install owned
# by another user, would try to chown the shared prefix to this user. Only run
# the installer when no brew binary exists anywhere on disk.
find_brew() {
  local b
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$b" ] && { printf '%s' "$b"; return 0; }
  done
  command -v brew 2>/dev/null   # last resort: a non-standard prefix already on PATH
}

BREW_BIN="$(find_brew)"
if [ -z "$BREW_BIN" ]; then
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW_BIN="$(find_brew)"
fi
# Put brew on PATH for the rest of this run.
eval "$("$BREW_BIN" shellenv)"
success "Homebrew ready."

# ---------------------------------------------------------------------------
# 3. Packages — everything lives in the Brewfile (formulae, casks, VS Code exts)
# ---------------------------------------------------------------------------
# AeroSpace's cask lives in a third-party tap. Newer Homebrew refuses to load
# casks from untrusted taps, so trust it up front — otherwise `brew bundle`
# aborts on aerospace. Safe to run every time (no-op once trusted).
brew tap nikitabobko/tap >/dev/null 2>&1 || true
brew trust nikitabobko/tap >/dev/null 2>&1 || true

info "Installing packages from Brewfile (this can take a while)..."
# Non-fatal by design: a single cask/font/tap failure shouldn't abort the whole
# setup — the later steps that depend on brew (mise, fish) are individually
# guarded, and the rest (symlinks, SSH, macOS defaults) don't need brew at all.
# But we don't paper over it: record the failure, warn loudly at the end, and
# exit non-zero so it's visible to a human and to automation.
BREW_BUNDLE_OK=1
if brew bundle --file="$DOTFILES/Brewfile"; then
  success "Packages installed."
else
  BREW_BUNDLE_OK=0
  warn "brew bundle had failures — some packages may be missing (see output above)."
fi

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
# Clear a pre-existing broken symlink first (e.g. one left pointing at an old
# dotfiles layout), otherwise the cp below would follow it and fail.
if [ -L "$HOME/.gitconfig.local" ] && [ ! -e "$HOME/.gitconfig.local" ]; then
  rm -f "$HOME/.gitconfig.local"
fi
if [ ! -e "$HOME/.gitconfig.local" ]; then
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
  # `fisher install jorgebucaran/fisher` persists fisher itself (functions/
  # fisher.fish) so the command survives into new shells; just sourcing it
  # transiently does not, and also strips fisher from fish_plugins. Then
  # `fisher update` installs the rest of the plugins listed in fish_plugins.
  "$FISH_BIN" -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && fisher update" || \
    warn "fisher install skipped — run 'fisher update' inside fish later."
fi

# ---------------------------------------------------------------------------
# 8. macOS defaults
# ---------------------------------------------------------------------------
if [ "$SKIP_MACOS" != "1" ]; then
  info "Applying macOS defaults..."
  bash "$DOTFILES/macos/defaults.sh"
fi

if [ "$BREW_BUNDLE_OK" -eq 1 ]; then
  success "Done. Open a new terminal (or log out/in) for everything to take effect."
else
  warn "Done — but some Brewfile packages failed to install."
  warn "  All other steps (dotfiles, SSH, shell, macOS defaults) completed."
  warn "  Re-run after fixing the cause:  brew bundle --file=\"$DOTFILES/Brewfile\""
  exit 1
fi
