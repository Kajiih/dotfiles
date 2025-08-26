#!/usr/bin/env nu

print (ansi attr_bold) ("Installing Spotify and Spicetify:" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

brew install --cask spotify
brew install spicetify-cli

# Maybe also install the marketplace https://github.com/spicetify/marketplace
# Also backup marketplace and import (file in spicetify config folder) with: https://github.com/spicetify/marketplace/wiki#back-up-marketplace
