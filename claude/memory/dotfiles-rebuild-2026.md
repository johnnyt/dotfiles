---
name: dotfiles-rebuild-2026
description: New dotfiles repo at ~/dotfiles-new replacing the old ~/dotfiles
metadata: 
  node_type: memory
  type: project
  originSessionId: 9f138865-027c-4416-aef1-3c58ac090965
---

In June 2026 (for a new laptop) JohnnyT started a clean dotfiles repo at
`~/dotfiles-new`, intended to replace the old `~/dotfiles` (github.com:johnnyt/dotfiles)
and supersede earlier experiments: `~/titan` (SaltStack, inherited from another
engineer — to be rewritten if reused), `~/dots` (abandoned salt reboot), and
`~/repos/github/nix-dotfiles` (Nix flakes, dormant).

Decisions: **lean into brew + mise**. Shell = **fish**. Editors = **nvim + VS Code**.
Terminal = **Ghostty**. macOS defaults = curated dev-focused script.
Single `install.sh` orchestrates: Xcode CLT → Homebrew → `brew bundle` (Brewfile is
the one source of truth; languages excluded, mise owns those) → symlinks → `mise install`
→ fish default shell + fisher → `macos/defaults.sh`.

When ready, plan is to `mv ~/dotfiles ~/dotfiles-old && mv ~/dotfiles-new ~/dotfiles`
and push. The old live `~/.tmux.conf` symlinked into `~/titan`; tmux config was
rewritten clean in the new repo.
