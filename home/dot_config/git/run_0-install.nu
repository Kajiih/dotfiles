#!/usr/bin/env nu

print (ansi attr_bold) ("Installing git" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

brew install git
brew install pre-commit
brew install git-delta
