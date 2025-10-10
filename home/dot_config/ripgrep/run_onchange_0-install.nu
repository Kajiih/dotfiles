#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "ripgrep" --brew "ripgrep" --apt "ripgrep" --check-installed "rg"
