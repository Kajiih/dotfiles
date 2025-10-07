#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/install_package.nu

install-package "neovim" --brew "neovim" --apt "neovim" --check-cmd "nvim"
