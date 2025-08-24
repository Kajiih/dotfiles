#!/usr/bin/env nu

# === atuin ===
print (ansi attr_bold) ("Installing cargo packages:" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

mkdir ~/.local/share/atuin/
atuin init nu | save --force ~/.local/share/atuin/init.nu

atuin login --username $env.USERNAME --key $env.ATUIN_KEY --password $env.ATUIN_PASSWORD
