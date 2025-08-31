use std "path add"

# https://carapace-sh.github.io/carapace-bin/setup.html#nushell
path add "/opt/homebrew/bin"
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# https://github.com/ajeetdsouza/zoxide#installation
zoxide init nushell | save -f ~/.zoxide.nu
