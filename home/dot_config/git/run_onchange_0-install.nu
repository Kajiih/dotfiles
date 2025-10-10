#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package

install-package "git" --brew "git" --apt "git"
install-package "pre-commit" --brew "pre-commit" --apt "pre-commit"
install-package "git-delta" --brew "git-delta" --check-installed "delta" # TODO: Add install method for linux
