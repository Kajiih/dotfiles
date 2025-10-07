#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/install_package.nu

install-package "git" --brew "git" --apt "git"
install-package "pre-commit" --brew "pre-commit" --apt "pre-commit"
install-package "git-delta" --brew "git-delta" --check-cmd "delta" # TODO: Add install method for linux
