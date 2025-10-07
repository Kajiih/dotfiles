#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/install_package.nu

install-package "bat" --brew "bat" --apt "bat"
install-package "bat-extras" --brew "bat-extras" --check-cmd "batgrep" # Add install method for linux
