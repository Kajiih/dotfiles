#!/usr/bin/env nu

# Run only on macOS
if (sys host | get name) != "Darwin" {
    print (ansi attr_bold) ("Skipping macOS settings" | ansi gradient --fgstart '0xffc040' --fgend '0xff8040') (ansi reset)
    exit 0
} else {
    print (ansi attr_bold) ("Applying macOS settings" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)
    print (ansi attr_bold) ("Reminder: Turn off 'Open folders in tabs instead of new windows' manually in Finder preferences." | ansi gradient --fgstart '0xffc040' --fgend '0xff8040') (ansi reset)
}

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
