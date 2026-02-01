#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package
use ~/.local/share/chezmoi/helpers/theme.nu print-info

install-package "spotify" --cask "spotify"
install-package "spicetify-cli" --brew "spicetify-cli" --check-installed "spicetify"

# Block spotify auto updates
spicetify restore backup apply
spicetify spotify-updates block

print-info "Backed up marketplace settings located at ~/.config/spicetify/marketplace_settings_backup.json"

# Maybe also install the marketplace https://github.com/spicetify/marketplace
# Also backup marketplace and import (file in spicetify config folder) with: https://github.com/spicetify/marketplace/wiki#back-up-marketplace
