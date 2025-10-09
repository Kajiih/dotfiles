#!/usr/bin/env nu

source ~/.local/share/chezmoi/helpers/theme.nu

print-header("Installing Rust...")

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
