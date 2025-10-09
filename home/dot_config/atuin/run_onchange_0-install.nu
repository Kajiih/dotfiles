#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

# Install atuin, providing options for multiple package managers.
install-package "atuin" --brew "atuin" --cargo "atuin"
