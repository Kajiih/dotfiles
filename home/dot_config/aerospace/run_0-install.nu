#!/usr/bin/env nu

print (ansi attr_bold) ("Installing Aerospace:" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

brew install --cask nikitabobko/tap/aerospace
