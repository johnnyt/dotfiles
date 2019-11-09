#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

info "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

info "Installing XCode command line tools..."
if xcode-select --print-path &>/dev/null; then
    success "XCode command line tools already installed."
elif xcode-select --install &>/dev/null; then
    success "Finished installing XCode command line tools."
else
    error "Failed to install XCode command line tools."
fi

if ! command -v brew >/dev/null; then
  info "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    #append_to_zshrc '# recommended by brew doctor'

    # shellcheck disable=SC2016
    #append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  info "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

info "Updating Homebrew formulae ... (FIND WAY TO SPEED THIS UP)"
#brew update --force # https://github.com/Homebrew/brew/issues/1151


HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi


# Package control must be executed first in order for the rest to work
./packages/setup.sh

./asdf/setup.sh
./fish/setup.sh
./git/setup.sh
./macos/setup.sh
./vim/setup.sh

#find * -name "setup.sh" -not -wholename "packages*" | while read setup; do
#    ./$setup
#done

success "Finished installing Dotfiles"
