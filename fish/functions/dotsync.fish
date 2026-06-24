function dotsync --description "Pull dotfiles and re-apply (idempotent install.sh)"
    set -l dots "$HOME/dotfiles"
    if not test -d "$dots/.git"
        echo "dotsync: no dotfiles repo at $dots" >&2
        return 1
    end

    pushd "$dots" >/dev/null

    # Refuse to sync over uncommitted work — commit or stash it first, otherwise
    # a pull could clobber half-finished edits.
    if not git diff --quiet; or not git diff --cached --quiet
        echo "dotsync: uncommitted changes — commit or stash before syncing:" >&2
        git status --short
        popd >/dev/null
        return 1
    end

    echo "▸ Pulling latest dotfiles…"
    if not git pull --ff-only
        echo "dotsync: pull was not a fast-forward — resolve manually." >&2
        popd >/dev/null
        return 1
    end

    echo "▸ Re-applying via install.sh…"
    # Pass through any args, e.g.  env SKIP_MACOS=1 dotsync  to skip the macOS pass.
    ./install.sh $argv
    set -l rc $status

    popd >/dev/null
    return $rc
end
