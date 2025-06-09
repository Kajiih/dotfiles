#!/usr/bin/env nu
# === atuin ===
mkdir ~/.local/share/atuin/
atuin init nu | save --force ~/.local/share/atuin/init.nu

atuin login --username $env.USERNAME --key $env.ATUIN_KEY --password $env.ATUIN_PASSWORD
