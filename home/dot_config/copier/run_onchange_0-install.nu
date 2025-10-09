#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "copier" --uv "copier --with copier-templates-extensions"
