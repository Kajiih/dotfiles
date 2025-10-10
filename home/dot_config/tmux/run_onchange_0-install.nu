#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "tmux" --brew "tmux" --apt "tmux"
install-package "tmux plugin manager" --brew "tpm" --apt "tmux-plugin-manager"
