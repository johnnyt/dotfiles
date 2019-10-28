#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~)"

info "Setting up Vim..."

find . -name ".vim*" | while read fn; do
    fn=$(basename $fn)
    symlink "$SOURCE/$fn" "$DESTINATION/$fn"
done

if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  mkdir -p $HOME/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim $HOME/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +qall

success "Finished setting up Vim."
