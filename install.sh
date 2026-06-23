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

# ---------------------------------------------------------------------------
# bootstrap: this script may be curl-piped before the repo exists on disk.
# If so, clone it and re-exec from the cloned copy.
# ---------------------------------------------------------------------------
REPO_URL="https://github.com/johnnyt/dotfiles"
TARGET="$HOME/dotfiles"
if [ ! -f "$DOTFILES/Brewfile" ]; then
  info "Cloning dotfiles to $TARGET ..."
  command -v git >/dev/null 2>&1 || xcode-select --install || true
  git clone "$REPO_URL" "$TARGET"
  exec "$TARGET/install.sh"
fi

# ---------------------------------------------------------------------------
# 1. Xcode command line tools (git, clang, make, ...)
# ---------------------------------------------------------------------------
if xcode-select --print-path >/dev/null 2>&1; then
  success "Xcode command line tools already installed."
else
  info "Installing Xcode command line tools..."
  xcode-select --install || true
  warn "Re-run this script once the CLT installer finishes."
  exit 0
fi

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

info "Linking dotfiles..."
link git/gitconfig          .gitconfig
link git/gitignore_global   .gitignore_global
link mise/config.toml       .config/mise/config.toml
link starship/starship.toml .config/starship.toml
link ghostty/config         .config/ghostty/config
link tmux/tmux.conf         .tmux.conf
link fish/config.fish       .config/fish/config.fish
link fish/fish_plugins      .config/fish/fish_plugins
link fish/functions         .config/fish/functions
link nvim                   .config/nvim
link vscode/settings.json   "Library/Application Support/Code/User/settings.json"

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
# 6. fish — set as default shell + install plugins (fisher)
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
# 7. macOS defaults
# ---------------------------------------------------------------------------
if [ "$SKIP_MACOS" != "1" ]; then
  info "Applying macOS defaults..."
  bash "$DOTFILES/macos/defaults.sh"
fi

success "Done. Open a new terminal (or log out/in) for everything to take effect."
