#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/theme.nu [ print-header print-warning ]

# Run only on macOS
if (sys host | get name) != "Darwin" {
    print-header "Skipping macOS settings"
    exit 0
} else {
    print-header "Applying macOS settings"
    print-warning "Reminder: Turn off 'Open folders in tabs instead of new windows' manually in Finder General Settings. Also remember to remap caps lock to escape and disable spotlight shortcuts in Keyboard Shortcuts settings."
}

# === Keyboard ===
# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
defaults write -g InitialKeyRepeat -float 10.0
defaults write -g KeyRepeat -float 1.0

# Disable press and hold for key variations to enable key repetitions
defaults write -g ApplePressAndHoldEnabled -bool false

# === Mouse ===
defaults write -g com.apple.mouse.scaling 0.125

# === Dock ===
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.30
# Add a small spacer tile
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
# Disable “Show recent applications in Dock”
defaults write com.apple.dock show-recents -bool false

killall Dock

# === Finder ===
# Sort folders first
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

# Show filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Change default view to Column
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Open Download folder by default
defaults write com.apple.finder NewWindowTarget PfDL
# Search in current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# === DS_Store files ===
# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Avoid creating .DS_Store files on USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# === Screenshots ===
defaults write com.apple.screencapture location ~/Documents/Screenshots

# Apply changes
killall Finder
killall SystemUIServer
