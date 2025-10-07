#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/install_package.nu

# Install atuin, providing options for multiple package managers.
install-package "atuin" --brew "atuin" --cargo "atuin"
