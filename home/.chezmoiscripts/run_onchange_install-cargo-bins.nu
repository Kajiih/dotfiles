#!/usr/bin/env nu
print (ansi attr_bold) ("Installing cargo packages:" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

(
    cargo binstall
    bws
)
