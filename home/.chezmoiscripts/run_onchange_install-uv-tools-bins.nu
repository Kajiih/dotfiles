#!/usr/bin/env nu

print (ansi attr_bold) ("Installing uv tools packages:" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)
(
    uv tool install
    copier --with copier-templates-extensions
)
