# Resolve a Nushell command alias to its full expansion chain.
# 
# This command performs a greedy expansion of aliases. It isolates the head 
# (command) from the tail (arguments) and recursively lookups the head in the 
# current scope.
# 
# Returns:
#   The list of the full resolution path. Index 0 is the input; the last index 
#   is the final expanded command.
@search-terms alias expansion resolution chain flatten
@category Aliases
@example "Resolve a simple alias" { resolve-alias-chain ll }
@example "Resolve nested aliases" {
    alias first_alias = ls -a
    alias second_alias = first_alias -d
    alias third_alias = second_alias -s

    resolve-alias-chain third_alias
}
@example "Input is not an alias" { resolve-alias-chain ls }
export def resolve-alias-chain [
    cmd: string # The alias or command to resolve
]: nothing -> list<string> {
    mut current_full_cmd = $cmd
    mut chain = [$cmd]
    mut seen_aliases = []

    loop {
        # Isolate the first word (the potential alias name) and the rest of the command
        let parts = ($current_full_cmd | parse -r '^(?P<head>\S+)(?P<tail>.*)$' | first)
        let alias_name = $parts.head
        let rest = $parts.tail | str trim

        # Detect recursion
        if $alias_name in $seen_aliases {
            break
        }
        $seen_aliases = ($seen_aliases | append $alias_name)

        # Look up the expansion in the current scope
        let expansion = (scope aliases | where name == $alias_name | get -o 0.expansion)

        if ($expansion == null) {
            break
        }

        # Build the new expanded command: [expansion] + [remaining flags/args]
        $current_full_cmd = if ($rest | is-empty) {
            $expansion
        } else {
            $"($expansion) ($rest)"
        }

        $chain = ($chain | append $current_full_cmd)
    }

    $chain
}

export def run-tests [] {
    use std assert

    alias first_alias = ls -a
    alias second_alias = first_alias -d
    alias third_alias = second_alias -s
    let resolved_chain = (resolve-alias-chain third_alias)

    assert equal $resolved_chain ["third_alias" "second_alias -s" "first_alias -d -s" "ls -a -d -s"]
}

export def run-benchmark [] {
    # === Parsing Methods ===
    # Deep alias chain setup
    alias a1 = ls
    alias a2 = a1 -a
    alias a3 = a2 -l
    alias a4 = a3 -d
    alias a5 = a4 -s

    let test_cmd = "a5 -m"

    # Implementation A: Split/Skip/Join
    def profile-split [cmd] {
        let parts = ($cmd | split row -r '\s+')
        let head = ($parts | first)
        let rest = ($parts | skip 1 | str join ' ')
        return [$head $rest]
    }

    # Implementation B: Regex Parse
    def profile-parse [cmd] {
        let parts = ($cmd | parse -r '^(?P<head>\S+)(?P<tail>\s.*)?$' | first)
        return [$parts.head ($parts.tail | str trim)]
    }

    # Run Benchmark
    print "Profiling Split/Skip/Join..."
    let time_split = (timeit { 1..20000 | each { profile-split $test_cmd } })

    print "Profiling Regex Parse..."
    let time_parse = (timeit { 1..20000 | each { profile-parse $test_cmd } })

    # Results Table
    [[Method Duration]; [Split-Skip-Join $time_split] [Regex-Parse $time_parse]] | print
}
