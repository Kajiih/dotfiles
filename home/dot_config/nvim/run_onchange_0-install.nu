#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "neovim" --brew "neovim" --apt "neovim" --check-cmd "nvim"
