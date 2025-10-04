#!/usr/bin/env nu

print (ansi attr_bold) ("Installing Starship:" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

brew install starship
