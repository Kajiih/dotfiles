# Omnihelp: Unified helper function to display help information with bat highlighting,
# supporting built-in commands, external commands, aliases, and modules.
# 
# It doesn't (and won't ever) support piped input.
# 
# TODO(P2): Check why it sometimes runs the script when using on one and prevent that
# TODO(P2): Check if it is possible for help to show the name of the module instead of "main" after usage: Track this: https://github.com/nushell/nushell/issues/10707

use std [help repeat]
use std-rfc/str

use resolve_alias_chain.nu [resolve-alias-chain ISOLATE_POTENTIAL_ALIAS_REGEX]

# Extract the command part by stopping at the first "-flag" (space + dash).
# ^(?P<cmd>.*?) : Anchors to start; captures the command non-greedily.
# (?: ... )? : Optional non-capturing group. Handles the flag separator if present.
# \s+-.* : Matches a whitespace followed by a dash and the rest of the line.
const ISOLATE_COMMAND_PART_REGEX = '^(?P<cmd>.*?)(?:\s+-.*)?$'

# Extract the help information for a command or alias, resolving aliases.
#
# Returns:
#  A table with three columns:
#   - full: The full alias expansion string.
#   - command: The isolated command part.
#   - help: The result of `help <command>` (or a fallback message).
def extract-alias-chain-helps [
    cmd: string
]: nothing -> table<full: string, command: string, help: string> {
    resolve-alias-chain $cmd
    | wrap full
    | insert command {|row| 
        $row.full 
        | parse -r $ISOLATE_COMMAND_PART_REGEX 
        | first 
        | get cmd 
    }
    | insert help {|row| help $row.command}
}

# Format an intermediate alias section.
def format-alias-section [
    name: string
    expansion: string
    help_message: string
]: nothing -> string {
    let expansion_message = (
        if $name == $expansion { "" } else { $" \(full expansion: (ansi i)($expansion)(ansi rst_i)\)" }
    )
    $"(ansi cyan)# ------ Alias: (ansi i)($name)(ansi rst_i) ------($expansion_message)(ansi reset)
($help_message)
"
}

# Format the final resolved command section.
def format-final-section [
    name: string
    expansion: string
    help_message: string
    language: string = "help"
]: nothing -> string {
    let expansion_message = (
        if $name == $expansion { "" } else { $" \(full expansion: (ansi i)($expansion)(ansi rst_i)\)" }
    )
    $"(ansi yellow)# ====== (ansi i)($name)(ansi rst_i) ======($expansion_message)(ansi reset)
($help_message | bat --plain --language=($language) --force-colorization --paging=never)
"
}


def omnihelp [
    ...input: string
    --man (-m) # Display manual page instead of help
]: nothing -> string nothing -> nothing {
    $env.NU_HELPER  = if $man {"man"} else {"--help"}

    let alias_chain = extract-alias-chain-helps ($input | str join ' ')

    let final_command = $alias_chain | last
    let aliases = $alias_chain | drop 1

    let formatted_aliases = ($aliases | each {|row|
        let alias_name = ($row.full | parse -r $ISOLATE_POTENTIAL_ALIAS_REGEX | first | get head)
        format-alias-section $alias_name $row.full $row.help
    })

    let has_nushell_help = (
        $final_command.command in (scope commands | get name)
        or $final_command.command in (scope modules | get name)
        or $final_command.command in (scope externs | get name)
    )
    let language = if $has_nushell_help { "markdown" } else { "help" }

    let formatted_final = format-final-section $final_command.command $final_command.full $final_command.help $language

    $formatted_aliases | append $formatted_final | str join "\n" | bat --plain
}


# Syntax highlighted help information for a any command, resolving aliases.
#
# Combines help messages from all intermediate aliases, and the actual 
# underlying command.
@search-terms help explain inspect usage docs
@category debug
@example "Show help for a builtin command" { omnihelp open }
@example "Show help for a module" { omnihelp str }
@example "Show help for an external command" { omnihelp git }
@example "Show help for a subcommand" { omnihelp git log }
@example "Show help for a simple alias" { omnihelp ll }
@example "Show help for a nested alias" {
    alias first_alias = ls -a
    alias second_alias = first_alias -d
    alias third_alias = second_alias -s

    omnihelp third_alias
}
export def main [
    ...input: string
    # --man (-m) # TODO(P2): Add man flag to main
]: [
    nothing -> string
    nothing -> nothing
] {
    omnihelp ...$input
}



# === Test cases ===
# h str
# h str trim
# h ls
# h ls a  -> improve error to that it shows explicitly that "ls a" is unknown (in the error message)

# h bws_secrets -> Should display that it's a module
# h bws_secrets load-all -> Should display that it's a command (from module bws_secrets?)

# h dua
# h dua interactive
# also try on an alias of "h dua"
# hh "dua interactive" -> Should work same as without ""

# h eza
# h lz
# h lz xxx -> Should fail showing that the command doesn't exist
# h lzt

# h git -> git also has a git help ... better than --help
# h git commit

# h security -> no --help but security help ... (currently displays a bad error message without hilighting)
# h security leaks -> why no syntax hilighting? it's weird, anyway

# h grep -> displays an error message instead of help

# operators: -> not supported
# in


# BROKEN
def run-tests [] {
    use std assert

    print "(ansi yellow)🧪 Starting Omnihelp Tests...(ansi reset)"

    # === 1. Builtin Commands ===
    print "   Checking builtin: (ansi cyan)ls(ansi reset)..."
    let res = (omnihelp ls)
    assert str contains $res "List the files"

    # === 2. Subcommands ===
    print "   Checking subcommand: (ansi cyan)str trim(ansi reset)..."
    let res = (omnihelp str trim)
    assert str contains $res "Trim whitespace"

    # === 3. Modules ===
    print "   Checking module: (ansi cyan)str(ansi reset)..."
    let res = (omnihelp str)
    # Different versions of Nu might verify phrasing, looking for key terms
    assert str contains $res "string"

    # === 4. Alias Chains ===
    print "   Checking alias chain: (ansi cyan)my_ll -> ls -l(ansi reset)..."
    
    # Define temporary aliases for the test context
    alias my_ls = ls
    alias my_ll = my_ls -l
    
    let res = (omnihelp my_ll)
    
    # Check for Intermediate Alias Header (Cyan)
    assert str contains $res "Alias: (ansi i)my_ll(ansi rst_i)"
    # Check for Expansion info
    assert str contains $res "Expansion: my_ls -l"
    # Check for Final Command Header (Yellow)
    assert str contains $res "ls" 

    # === 5. External Commands ===
    if (which git | is-not-empty) {
        print "   Checking external: (ansi cyan)git(ansi reset)..."
        let res = (omnihelp git)
        # Git help usually contains 'usage' or 'git'
        assert str contains ($res | str downcase) "usage"
        
        print "   Checking external subcommand: (ansi cyan)git commit(ansi reset)..."
        let res_sub = (omnihelp git commit)
        assert str contains ($res_sub | str downcase) "commit"
    }

    # === 6. Edge Cases & Errors ===
    
    # Test: Invalid Command
    print "   Checking unknown command: (ansi cyan)lz xxx(ansi reset)..."
    try {
        omnihelp lz xxx
        print "   (ansi red)WARNING: 'lz xxx' did not fail. Check error propagation.(ansi reset)"
    } catch {
        print "   -> Successfully caught error for unknown command."
    }

    # Test: 'grep' (Known to exit with code 1 on --help in some systems)
    if (which grep | is-not-empty) {
        print "   Checking problematic external: (ansi cyan)grep(ansi reset)..."
        try {
            let _ = (omnihelp grep)
            print "   -> grep help displayed successfully."
        } catch {
            print "   -> (ansi yellow)Notice: grep failed (expected if return code is 1 and try/catch is missing).(ansi reset)"
        }
    }

    # Test: 'ls a' (Valid command 'ls', invalid arg 'a')
    # This addresses your TODO about improving the error message
    print "   Checking invalid arg: (ansi cyan)ls a(ansi reset)..."
    try {
        omnihelp ls a
        print "   -> 'ls a' ran. (Check output to see if it showed 'ls' help or error)"
    } catch {
        print "   -> 'ls a' failed."
    }

    print "\n(ansi green)✅ All tests execution finished.(ansi reset)"
}
