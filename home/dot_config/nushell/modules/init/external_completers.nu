# Functions to setup external completers.

# https://www.nushell.sh/cookbook/external_completers.html#putting-it-all-together

# Return a personalized external completer.
# 
# Uses Carapace by default, and sets fish for specific commands.
# Also sets up zoxide completions.
export def create-external-completer [
    --carapace-completer: closure, 
    --fish-completer: closure, 
    --zoxide-completer: closure
    ]: nothing -> closure {
    let completer = {|spans: list<string>|
        # let expanded_alias = scope aliases
        # | where name == $spans.0
        # | get -i 0.expansion
        let expanded_alias = resolve-alias-chain $spans.0 | last
        # print $expanded_alias

        let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
        } else {
            $spans
        }
        # print $spans

        match $spans.0 {
            # carapace completions are incorrect for nu
            nu => $fish_completer
            # fish completes commits and branch names in a nicer way
            git => $fish_completer
            # carapace doesn't have completions for asdf
            asdf => $fish_completer
            # use zoxide completions for zoxide commands
            __zoxide_z|__zoxide_zi => $zoxide_completer
            _ => $carapace_completer
        } | do $in $spans
    }

    return $completer
}


# This completer will use carapace by default
# TODO: Remove already used flags? -> already the case it seems

