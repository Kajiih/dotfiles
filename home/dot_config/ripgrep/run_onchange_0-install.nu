#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/install_package.nu

install-package "ripgrep" --brew "ripgrep" --apt "ripgrep" --check-cmd "rg"
