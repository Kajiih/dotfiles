#!/usr/bin/env nu

print (ansi attr_bold) ("Installing Borders (windows border on macOS):" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

brew tap FelixKratz/formulae
brew install borders
