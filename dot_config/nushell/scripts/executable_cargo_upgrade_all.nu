#!/usr/bin/env nu

# Upgrade all cargo binaries. Might not work anymore.
# From https://github.com/rust-lang/cargo/issues/9527#issuecomment-2424093915
cargo install --list
| parse "{package} v{version}:"
| get package
| each {|p| cargo install $p --locked }
