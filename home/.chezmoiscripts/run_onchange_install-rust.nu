#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/theme.nu print-header

print-header "Installing Rust..."

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
