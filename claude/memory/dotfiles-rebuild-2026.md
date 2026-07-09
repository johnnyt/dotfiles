---
name: dotfiles-rebuild-2026
description: Rebuilt dotfiles (brew+mise+fish+ghostty) now live at ~/dotfiles
metadata: 
  node_type: memory
  type: project
  originSessionId: 9f138865-027c-4416-aef1-3c58ac090965
---

In June 2026 (for a new laptop) JohnnyT rebuilt his dotfiles from scratch. The
rebuild started in a scratch `~/dotfiles-new` repo and, once ready, was swapped
into place — as of July 2026 it **now lives at `~/dotfiles`** (github.com:johnnyt/dotfiles);
`~/dotfiles-new` no longer exists. The active `~/.config/fish/config.fish` symlinks
to `~/dotfiles/fish/config.fish`. It supersedes earlier experiments: `~/titan`
(SaltStack, inherited from another engineer — to be rewritten if reused), `~/dots`
(abandoned salt reboot), and `~/repos/github/nix-dotfiles` (Nix flakes, dormant).

Decisions: **lean into brew + mise**. Shell = **fish**. Editors = **nvim + VS Code**.
Terminal = **Ghostty**. macOS defaults = curated dev-focused script.
Single `install.sh` orchestrates: Xcode CLT → Homebrew → `brew bundle` (Brewfile is
the one source of truth; languages excluded, mise owns those) → symlinks → `mise install`
→ fish default shell + fisher → `macos/defaults.sh`.

The swap (`mv ~/dotfiles ~/dotfiles-old && mv ~/dotfiles-new ~/dotfiles`) has been
completed. The old live `~/.tmux.conf` symlinked into `~/titan`; tmux config was
rewritten clean in the new repo. mise now manages language runtimes (e.g. Flutter
pinned to 3.41.9 in `~/.config/mise/config.toml`); `mise activate fish` runs last
in config.fish so its shims take PATH precedence.
