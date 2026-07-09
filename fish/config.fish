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

# Homebrew — must load BEFORE the interactive block below, which inits tools
# installed via brew (starship, fzf, direnv). If brew isn't on PATH first, those
# `type -q` checks fail silently and you get no prompt / no key bindings.
test -x /opt/homebrew/bin/brew; and eval (/opt/homebrew/bin/brew shellenv)

# Android SDK — cmdline-tools installed via brew cask (android-commandlinetools);
# SDK packages under this root. Flutter finds it via its own config, but adb /
# emulator need to be on PATH for direct use. JDK is managed by mise.
set -gx ANDROID_HOME /opt/homebrew/share/android-commandlinetools
set -gx ANDROID_SDK_ROOT $ANDROID_HOME
fish_add_path $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator

# ---------------------------------------------------------------------------
# Interactive shell only
# ---------------------------------------------------------------------------
if status is-interactive
    # Aliases
    alias dc "docker compose"
    alias v  nvim
    alias r  ranger
    alias gn  "git checkout main"
    alias tn  "tmux new -s (basename (pwd))"
    alias tng "tmux new -s general"
    alias cat bat

    # Abbreviations — expand inline as you type (so they show up verbatim in
    # history). These previously lived only in fish universal variables
    # (~/.config/fish/fish_variables), which isn't version-controlled, so they
    # never followed to new machines. Defining them here fixes that.
    abbr -a g    git
    abbr -a ga   'git add'
    abbr -a gc   'git commit -m'
    abbr -a gco  'git checkout'
    abbr -a gd   'git diff'
    abbr -a gf   'git fetch'
    abbr -a gm   'git pull --ff-only'
    abbr -a gma  'git checkout master'
    abbr -a gp   'git push'
    abbr -a gs   'git status'
    abbr -a gst  'git status'
    abbr -a gba  'git branch -a'
    abbr -a l    'ls -lah'
    abbr -a bs   'brew services'
    abbr -a bx   'bundle exec'

    # fzf key bindings (Ctrl-R history, Ctrl-T files)
    type -q fzf; and fzf --fish | source

    # direnv
    type -q direnv; and direnv hook fish | source

    # starship prompt
    type -q starship; and starship init fish | source
end

# ---------------------------------------------------------------------------
# mise — activate last so its shims take precedence over other tools on PATH
# ---------------------------------------------------------------------------
type -q mise; and mise activate fish | source
