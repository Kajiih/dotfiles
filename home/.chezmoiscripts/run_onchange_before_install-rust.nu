#!/usr/bin/env nu

print (ansi attr_bold) ("Installing Rust..." | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
