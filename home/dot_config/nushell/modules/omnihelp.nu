# Omnihelp: Unified helper function to display help information with bat highlighting,
# supporting built-in commands, external commands, aliases, and modules.
use resolve_alias_chain.nu resolve-alias-chain

# Name ideas:
# Helpctopus
# helpx
# flashelp
# helpaged
# basedhelp

# TODO: Check why it sometimes runs the script when using on one and prevent that
# TODO? Add arguments to pass to the final bat?
# TODO: Detect subcommands in ...args to separate subcommands from --arguments and display if the item we run help on is a module or a command in the header
# TODO: Detect subcommands when the main command is an alias (subcommand disappears when resolving alias), e.g., `omnihelp chs`
# TODO: Handle commands and subcommands with a '-' inside, like `pre-commit run`
# TODO? Handle pipeline inputs?
def omnihelp [
    command: string # The command, module or alias to show help for
    ...args # Any arguments passed to the command
]: [
    nothing -> nothing nothing -> string
] {
    let alias_chain = resolve-alias-chain $command
    # Keep only the first part of the alias
    let alias_chain = $alias_chain | each {|a| $a | split words | first }

    mut aliases_help = (
        $alias_chain
        | drop
        | each {|a|
            let header = $"(ansi cyan)# ───── Alias: ($a) ─────(ansi reset)"
            $header + "\n" + (help $a)
        }
        | str join "\n\n"
    )
    if ($aliases_help | is-not-empty) {
        $aliases_help += "\n\n"
    }

    let actual_cmd = $alias_chain | last
    let full_command = if ($args | is-empty) {
        $actual_cmd
    } else {
        $actual_cmd + " " + ($args | str join ' ')
    }

    let cmd_help = if $actual_cmd in (scope aliases | get name) {
        # Recursive alias of external commands won't give proper help with `help ...`
        ^$actual_cmd ...$args --help
    } else try {
        help $full_command # TODO: Check why this doesn't work on help aliases and such
    } catch {
        ^$actual_cmd ...$args --help
    }

    let cmd_header = $"(ansi yellow)# ═════ ($full_command) ═════(ansi reset)"

    (
        $aliases_help + $cmd_header + "\n" + ($cmd_help | bat --plain --language=help --force-colorization --paging=never)
    ) | bat --plain
}

# Display syntax highlighted help information for a builtin or external command or a module, recursively resolving aliases.
#
# Combines help messages from all alias layers and the actual underlying command.
# If the command is not a builtin or module, it will try invoking it with `--help`.
# TODO: Check if it is possible for help to show the name of the module instead of "main" after usage: Track this: https://github.com/nushell/nushell/issues/10707
@search-terms help explain inspect usage docs
@category debug
@example "Show help for a simple alias" { omnihelp ll }
@example "Show help for a nested alias" { omnihelp myls }
@example "Show help for a builtin command" { omnihelp open }
@example "Show help for a module" { omnihelp str }
@example "Show help for an external command" { omnihelp git }
@example "Show help for a subcommand" { omnihelp git log }
export def main [
    command: string # The command, module or alias to show help for
    ...args # Any arguments passed to the command
]: [
    # nothing -> string
    nothing -> nothing
] {
    omnihelp $command ...$args
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

# operators: -> not supported
# in
