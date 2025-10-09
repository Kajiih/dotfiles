#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "bat" --brew "bat" --apt "bat"
install-package "bat-extras" --brew "bat-extras" --check-cmd "batgrep" # TODO: Add install method for linux
