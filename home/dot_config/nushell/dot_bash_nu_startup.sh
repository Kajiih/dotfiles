# shellcheck shell=bash
# This script is intended to be sourced by Bash during startup.

WHICH_NU="$(which nu)" 

# Check if:
# 1. Shell is interactive ($- =~ i)
# 2. Nushell executable exists (-x)
# 3. The current SHELL environment variable is NOT already Nushell
if [[ "$-" =~ i && -x "${WHICH_NU}" && ! "${SHELL}" -ef "${WHICH_NU}" ]]; then 
    # Use 'exec' to replace the Bash process with the Nushell process.
    exec env SHELL="${WHICH_NU}" "${WHICH_NU}" -i 
fi 
