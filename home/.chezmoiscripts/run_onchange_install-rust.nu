#!/usr/bin/env nu

use ~/.local/share/chezmoi/helpers/theme.nu print-header

if (which rustc | is-empty) {
print-header "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}
