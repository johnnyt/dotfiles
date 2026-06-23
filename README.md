# dotfiles

Personal macOS development setup. Brew + mise centric. One command to set up a
fresh machine.

## Install

On a brand-new Mac:

```sh
git clone https://github.com/johnnyt/dotfiles ~/dotfiles && ~/dotfiles/install.sh
```

Or fully bootstrapped from `curl` (the script clones itself if needed):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/johnnyt/dotfiles/main/install.sh)"
```

`install.sh` is idempotent — safe to re-run any time. It will:

1. Install Xcode command line tools
2. Install Homebrew
3. `brew bundle` everything in [`Brewfile`](./Brewfile)
4. Symlink configs into place (backing up anything pre-existing)
5. `mise install` the language toolchains
6. Set `fish` as the default shell and install its plugins
7. Apply [`macos/defaults.sh`](./macos/defaults.sh)

Skip the macOS tweaks with `SKIP_MACOS=1 ~/dotfiles/install.sh`.

## What's managed

| Area      | Tool                | Source                  | Linked to                       |
|-----------|---------------------|-------------------------|---------------------------------|
| Packages  | Homebrew            | `Brewfile`              | —                               |
| Runtimes  | mise                | `mise/config.toml`      | `~/.config/mise/config.toml`    |
| Shell     | fish                | `fish/`                 | `~/.config/fish/`               |
| Prompt    | starship            | `starship/starship.toml`| `~/.config/starship.toml`       |
| Terminal  | Ghostty             | `ghostty/config`        | `~/.config/ghostty/config`      |
| Multiplexer | tmux              | `tmux/tmux.conf`        | `~/.tmux.conf`                  |
| Editor    | Neovim              | `nvim/`                 | `~/.config/nvim`                |
| Editor    | VS Code             | `vscode/settings.json`  | VS Code `User/settings.json`    |
| Git       | git                 | `git/`                  | `~/.gitconfig`, etc.            |
| System    | macOS defaults      | `macos/defaults.sh`     | —                               |

## Day-to-day

- **Add a package:** edit `Brewfile`, then `brew bundle --file=~/dotfiles/Brewfile`.
- **Remove stragglers:** `brew bundle cleanup --file=~/dotfiles/Brewfile`.
- **Change a language version:** edit `mise/config.toml`, then `mise install`.
- **Per-machine git identity:** lives in `~/.gitconfig.local` (untracked).

## Languages (mise)

Language runtimes are **not** in the Brewfile — mise owns them, pinned in
`mise/config.toml`. Project-local overrides go in a project `mise.toml` /
`.tool-versions`.
