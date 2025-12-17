# shellcheck shell=bash
# This script ensures Nushell is used for interactive sessions.

# Add Nushell location to PATH if it's not already there
# It is currently installed via Rust's cargo
CARGO_BIN="$HOME/.cargo/bin"
if [[ -d "$CARGO_BIN" && :$PATH: != *:"$CARGO_BIN":* ]]; then
    export PATH="$CARGO_BIN:$PATH"
fi

WHICH_NU=$(command -v nu)

# Security Gate:
# [[ -t 0 ]]    : Is this an interactive terminal? (Prevents breaking scp/rsync/git)
# [[ -n ... ]]  : Is the WHICH_NU variable not empty? (Did we actually find nu?)
# [[ -x ... ]]  : Is the file found actually executable?
# [[ -z ... ]]  : Are we NOT already in Nushell? (Prevents infinite loops)
if [[ -t 0 && -n "$WHICH_NU" && -x "$WHICH_NU" && -z "$NU_VERSION" ]]; then
    export SHELL="$WHICH_NU"
    exec "$WHICH_NU" -i
fi

echo "bash_nu_startup: Nushell not launched (non-interactive session or Nushell not found)."
