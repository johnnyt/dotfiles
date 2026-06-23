# Brewfile — single source of truth for packages.
#   Apply with:  brew bundle --file=~/dotfiles/Brewfile
#   Prune extras: brew bundle cleanup --file=~/dotfiles/Brewfile
#
# Language runtimes (node, elixir, erlang, rust, ...) are intentionally NOT here
# — mise owns those. See mise/config.toml.

# ---------------------------------------------------------------------------
# Taps
# ---------------------------------------------------------------------------
tap "nikitabobko/tap"   # AeroSpace tiling WM

# ---------------------------------------------------------------------------
# CLI — core dev tooling
# ---------------------------------------------------------------------------
brew "git"
brew "gh"               # GitHub CLI (replaces hub)
brew "glab"             # GitLab CLI
brew "mise"             # runtime version manager
brew "direnv"           # per-directory env
brew "starship"         # prompt
brew "fish"             # shell
brew "tmux"
brew "neovim"
brew "ripgrep"          # rg — fast grep
brew "fd"               # fast find
brew "fzf"              # fuzzy finder
brew "jq"               # JSON wrangling
brew "tree"
brew "bat"              # cat with syntax highlighting
brew "ranger"           # TUI file manager
brew "sops"             # secrets encryption
brew "scc"              # lines-of-code / complexity
brew "bandwhich"        # per-process network usage
brew "overmind"         # Procfile process manager
brew "mas"              # Mac App Store CLI (drives the `mas` entries below)

# ---------------------------------------------------------------------------
# CLI — databases
# ---------------------------------------------------------------------------
brew "postgresql@17"
brew "pgcli"            # better psql REPL

# ---------------------------------------------------------------------------
# CLI — cloud / platform
# ---------------------------------------------------------------------------
brew "awscli"
brew "flyctl"          # fly.io
brew "ngrok"

# ---------------------------------------------------------------------------
# CLI — language servers / build helpers
# ---------------------------------------------------------------------------
brew "tree-sitter"
brew "tree-sitter-cli"
brew "elixir-ls"
brew "xcbeautify"      # prettier xcodebuild output
brew "xcresultparser"

# ---------------------------------------------------------------------------
# Fonts
# ---------------------------------------------------------------------------
cask "font-fira-code-nerd-font"

# ---------------------------------------------------------------------------
# GUI — daily drivers
# ---------------------------------------------------------------------------
cask "ghostty"                 # primary terminal
cask "visual-studio-code"
cask "claude"
cask "aerospace"               # tiling window manager (i3-style, config in aerospace/)
cask "docker-desktop"
cask "vivaldi"
cask "dropbox"
cask "lastpass"
cask "slack"
cask "zoom"
cask "postman"
cask "istat-menus"             # system monitoring in the menu bar

# ---------------------------------------------------------------------------
# GUI — optional / situational (uncomment as needed)
# ---------------------------------------------------------------------------
# cask "iterm2"
# cask "kitty"
# cask "spotify"
# cask "macdown"               # Markdown viewer
# cask "betaflight-configurator"
# cask "bambu-studio"          # 3D printing
# cask "blender"
# cask "steam"
# cask "battle-net"

# ---------------------------------------------------------------------------
# Mac App Store (via `mas`)
# ---------------------------------------------------------------------------
# Note: on current macOS, `mas` can only install apps already associated with
# the signed-in Apple ID. Open the App Store, sign in, and "get" Dato once if
# it isn't in your purchase history yet.
mas "Dato", id: 1470584107     # menu bar calendar / clock

# ---------------------------------------------------------------------------
# VS Code extensions
# ---------------------------------------------------------------------------
vscode "vscodevim.vim"
vscode "PKief.material-icon-theme"
vscode "azemoh.one-monokai"
