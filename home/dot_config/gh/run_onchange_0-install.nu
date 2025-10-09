#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "gh" --brew "gh" # TODO: Add installation for linux
