#!/usr/bin/env bash
#
# macos/defaults.sh — macOS system tweaks geared toward software development.
# Re-runnable. Close System Settings before running. A logout/restart is needed
# for some of these to fully take effect.
#
# Lineage: trimmed + modernized from mathiasbynens/dotfiles, dev-focused.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Set this machine's name (shows in Finder sidebar, Sharing, terminal host).
COMPUTER_NAME="${COMPUTER_NAME:-}"

echo "▸ Applying macOS dev defaults..."

# Ask for admin upfront and keep the sudo timestamp alive for this run.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Close System Settings so it doesn't override what we change.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

if [ -n "$COMPUTER_NAME" ]; then
  sudo scutil --set ComputerName "$COMPUTER_NAME"
  sudo scutil --set HostName "$COMPUTER_NAME"
  sudo scutil --set LocalHostName "$COMPUTER_NAME"
fi

###############################################################################
# Keyboard & text — the single biggest dev quality-of-life win                #
###############################################################################

# Blazing-fast key repeat (great for cursor movement in vim/editors).
defaults write NSGlobalDomain InitialKeyRepeat -int 15   # delay before repeat
defaults write NSGlobalDomain KeyRepeat -int 2           # repeat speed

# Disable press-and-hold accent menu so holding a key actually repeats it.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Turn off "smart" substitutions that mangle code/quotes.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Full keyboard access: Tab through all controls in dialogs.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Caps Lock -> Escape (no Karabiner). hidutil applies it now; the LaunchAgent
# reapplies it on every login since hidutil remaps don't survive a reboot.
hidutil property --set \
  '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' \
  >/dev/null
AGENT="com.local.KeyRemapping"
mkdir -p "${HOME}/Library/LaunchAgents"
cp "${SCRIPT_DIR}/LaunchAgents/${AGENT}.plist" "${HOME}/Library/LaunchAgents/${AGENT}.plist"
launchctl bootout "gui/$(id -u)/${AGENT}" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "${HOME}/Library/LaunchAgents/${AGENT}.plist" 2>/dev/null || true

###############################################################################
# Trackpad & input                                                            #
###############################################################################

# Tap to click.
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder — make it usable for development                                     #
###############################################################################

# Show all filename extensions and hidden files (dotfiles!).
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true

# Status bar + path bar, and show the full POSIX path in the title.
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Default to column view ("clmv"). Others: icnv, Nlsv, Flwv.
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Search the current folder by default (not the whole Mac).
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# No warning when changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Keep folders on top when sorting by name.
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Don't write .DS_Store files to network or USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder.
chflags nohidden ~/Library 2>/dev/null || true

###############################################################################
# Screenshots                                                                 #
###############################################################################

mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true
# Keep the floating thumbnail — it's how you drag a screenshot straight into an
# app (e.g. Claude) without digging it out of the Screenshots folder.
defaults write com.apple.screencapture show-thumbnail -bool true

###############################################################################
# Dock & Mission Control                                                       #
###############################################################################

defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0          # no hide delay
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock show-recents -bool false         # no recent apps
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock expose-animation-duration -float 0.12
defaults write com.apple.dock mru-spaces -bool false           # don't reorder Spaces
defaults write com.apple.dock show-process-indicators -bool true

# Hot corner: top-right = Lock Screen (no modifier key required).
# Corner action codes: 5=Start Screen Saver, 10=Put Display to Sleep,
# 13=Lock Screen, 1=disabled. To use the screen saver instead, change 13 -> 5.
defaults write com.apple.dock wvous-tr-corner -int 13
defaults write com.apple.dock wvous-tr-modifier -int 0

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Expand save & print panels by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Faster window resize animations.
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Don't prompt "are you sure you want to open this application?".
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Require password immediately after sleep / screen saver.
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Avoid creating duplicate-ridden "Open With" menus over time.
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Apply                                                                       #
###############################################################################

for app in Finder Dock SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "✓ macOS defaults applied. Some changes need a logout/restart."
