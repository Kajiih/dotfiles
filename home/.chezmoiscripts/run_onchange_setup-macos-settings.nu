#!/usr/bin/env nu

# Run only on macOS
if (sys host | get name) != "Darwin" {
    print (ansi attr_bold) ("Skipping macOS settings" | ansi gradient --fgstart '0xffc040' --fgend '0xff8040') (ansi reset)
    exit 0
} else {
    print (ansi attr_bold) ("Applying macOS settings" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)
    print (ansi attr_bold) ("Reminder: Turn off 'Open folders in tabs instead of new windows' manually in Finder General Settings. Also remember to remap caps lock to escape and disable spotlight shortucts in Keyboard Shortcuts settings." | ansi gradient --fgstart '0xffc040' --fgend '0xff8040') (ansi reset)
}

# === Key repeat ===
# https://apple.stackexchange.com/questions/10467/how-to-increase-keyboard-key-repeat-rate-on-os-x
defaults write -g InitialKeyRepeat -float 10.0
defaults write -g KeyRepeat -float 1.0

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
# Search in current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# === Desktop Services ===
# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Avoid creating .DS_Store files on USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Apply changes
killall Finder
killall SystemUIServer
