#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/install_package.nu

install-package "helix" --brew "helix" --check-cmd "hx"
