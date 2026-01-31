# Temporary change to that file because cargo is not updated to support nushell v0.110 where $nu.home-path is replaced by $nu.home-dir

use std/util "path add"
# path add $"($nu.home-path)/.cargo/bin"
path add $"($nu.home-dir)/.cargo/bin"
