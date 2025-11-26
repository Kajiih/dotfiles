#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "spotify" --cask "spotify"
install-package "spicetify-cli" --brew "spicetify-cli" --check-installed "spicetify"

# Maybe also install the marketplace https://github.com/spicetify/marketplace
# Also backup marketplace and import (file in spicetify config folder) with: https://github.com/spicetify/marketplace/wiki#back-up-marketplace

# TODO: P1: Test this
spicetify backup apply
spicetify restart
