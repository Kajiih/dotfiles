#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/theme.nu print-info
use ~/.local/share/chezmoi/helpers/install_package.nu install-package
use ~/.config/.chezmoi_variables.nu USE_ANDROID_AUTOMOTIVE_TOOLS

if not $USE_ANDROID_AUTOMOTIVE_TOOLS { exit }

install-package "scrcpy" --brew "scrcpy"
install-package "android-platform-tools" --cask "android-platform-tools"

print-info "Reminder: Also install AAE Toolbox."
