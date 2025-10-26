#!/usr/bin/env nu
use ~/.local/share/chezmoi/helpers/theme.nu print-header
use ~/.config/.chezmoi_variables.nu DEVICE_NAME

print-header "Setting up atuin:"

mkdir ~/.local/share/atuin/
atuin init nu | save --force ~/.local/share/atuin/init.nu

# Only sync Imoen
if $DEVICE_NAME == "Imoen" and (atuin status | str contains "You are not logged in") {
    atuin login --username $env.USERNAME --key $env.ATUIN_KEY --password $env.ATUIN_PASSWORD
}
