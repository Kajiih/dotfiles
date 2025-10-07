#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/install_package.nu

install-package "thefuck" --brew "thefuck" --check-cmd "thefuck"
