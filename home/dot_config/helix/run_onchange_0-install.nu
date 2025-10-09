#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "helix" --brew "helix" --check-cmd "hx"
# TODO: Add install method on linux
