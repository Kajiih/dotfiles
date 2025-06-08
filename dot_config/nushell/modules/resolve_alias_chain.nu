# Resolve a Nushell command alias to its full expansion chain
# 
# Recursively resolves an alias to its original base command, returning all intermediate alias names along the way.
# 
# The function returns an array of strings representing the alias resolution chain, ending with the actual command.
# If the input is not an alias, the array will contain only the original command.
# TODO: Return the concatenation of the aliases removing duplicate flags if necessary (expansion replaces the first word in expansion 1)
@search-terms alias expansion resolution chain
@category debug
@example "Resolve a single alias" { resolve-alias-chain ll }
@example "Resolve nested aliases" { resolve-alias-chain foo }
@example "Input is not an alias" { resolve-alias-chain ls }
export def resolve-alias-chain [
    cmd: string # The alias or command to resolve
]: nothing -> list<string> {
    mut current = $cmd
    mut expansion = $current

    mut chain = []
    mut seen_aliases = []  # Track the base aliases we've seen to detect recursion
    
    while $expansion != null {
        $current = ($expansion | split words | first)
        
        # Check if we've seen this alias before (recursion detected)
        if $current in $seen_aliases {
            $chain ++= [$expansion]
            break
        }
        
        $chain ++= [$expansion]
        $seen_aliases ++= [$current]

        $expansion = (scope aliases | where name == $current | get -i 0.expansion)
    }

    $chain
}
