#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/install_package.nu install-package
use ~/.config/.chezmoi_variables.nu IS_GOOGLE_SPECIFIC

install-package "fish" --brew "fish" --apt "fish"

if $IS_GOOGLE_SPECIFIC {
    sudo glinux-add-repo fish-google -b
    install-package "fish-google-config" --apt "fish-google-config"
}
