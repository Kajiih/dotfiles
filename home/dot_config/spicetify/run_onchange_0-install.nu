#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "spotify" --cask "spotify"
install-package "spicetify-cli" --brew "spicetify-cli" --check-installed "spicetify"

# Maybe also install the marketplace https://github.com/spicetify/marketplace
# Also backup marketplace and import (file in spicetify config folder) with: https://github.com/spicetify/marketplace/wiki#back-up-marketplace

# TODO: P1: Test this
try {
    print "Attempting to apply spicetify backup..."
    spicetify backup apply
    
    print "Restarting Spotify..."
    spicetify restart
} catch { |err|
    print $"(ansi red_bold)Spicetify failed:(ansi reset) ($err.msg)"
    print "Check if Spotify needs a manual update or if 'spicetify restore' is required."
}
