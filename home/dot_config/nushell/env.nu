use std "path add"

# https://carapace-sh.github.io/carapace-bin/setup.html#nushell
# Needs to be in env.nu to create the file before it is sourced in config.nu
path add "/opt/homebrew/bin"
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# https://github.com/ajeetdsouza/zoxide#installation
# Needs to be in env.nu to create the file before it is sourced in config.nu
zoxide init nushell | save -f ~/.zoxide.nu
