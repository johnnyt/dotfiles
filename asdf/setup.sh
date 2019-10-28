#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath .)"
DESTINATION="$(realpath ~/.asdf)"

info "Configuring asdf version manager ..."
if [ ! -d "$DESTINATION" ]; then
  git clone https://github.com/asdf-vm/asdf.git $DESTINATION
  cd $DESTINATION && git checkout "$(git describe --abbrev=0 --tags)" && cd -
fi

info "Adding asdf languages ..."
source "$HOME/.asdf/asdf.sh"
asdf_language "erlang"
asdf_language "elixir"

info "Setting up ruby ..."
asdf_language "ruby"
gem update --system
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

fancy_echo "Installing latest Node ..."
bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
asdf_language "nodejs"

success "Finished adding asdf languages"
