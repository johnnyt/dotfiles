# ~/.config/fish/config.fish

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
set -gx LANG   en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx EDITOR nvim
set -gx fish_term24bit 1

# Only auto-update Homebrew once a week
set -gx HOMEBREW_AUTO_UPDATE_SECS 604800

set -gx LS_COLORS "di=38;5;27:fi=38;5;7:ln=38;5;51:pi=40;38;5;11:so=38;5;13:or=38;5;197:mi=38;5;161:ex=38;5;9:"

# Erlang shell history
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -gx KERL_BUILD_DOCS true

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
fish_add_path ~/bin ~/.local/bin ~/.mix/escripts

# ---------------------------------------------------------------------------
# Interactive shell only
# ---------------------------------------------------------------------------
if status is-interactive
    # Aliases
    alias dc "docker compose"
    alias v  nvim
    alias r  ranger
    alias g  git
    alias gma "git checkout master"
    alias gn  "git checkout main"
    alias tn  "tmux new -s (basename (pwd))"
    alias tng "tmux new -s general"
    alias cat bat

    # fzf key bindings (Ctrl-R history, Ctrl-T files)
    type -q fzf; and fzf --fish | source

    # direnv
    type -q direnv; and direnv hook fish | source

    # starship prompt
    type -q starship; and starship init fish | source
end

# ---------------------------------------------------------------------------
# Homebrew + mise (must come last so its shims take precedence)
# ---------------------------------------------------------------------------
test -x /opt/homebrew/bin/brew; and eval (/opt/homebrew/bin/brew shellenv)
type -q mise; and mise activate fish | source
