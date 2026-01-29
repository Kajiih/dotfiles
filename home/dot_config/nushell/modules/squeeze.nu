
def squeeze [
    --head: int = 7 
    --truncation-indicator: string = "..." 
    --tail: int = 2 
]: nothing -> string {
    let input = $in
    let lines = ($input | lines)
    let remaining = ($lines | length) - $head - $tail

    if $remaining <= 1 { return $input }

    let truncation_message = $"(ansi blue)($truncation_indicator) ($remaining) more lines(ansi reset)"

    [
        ...($lines | first $head)
        $truncation_message
        ...($lines | last $tail)
    ] | str join "\n"
}


# Return a squeezed version of a string including an extract of the head and the tail.
export def main [
    --head: int = 7 
    --truncation-indicator: string = "..." 
    --tail: int = 2 
]: nothing -> string {
    squeeze --head $head --truncation-indicator $truncation_indicator --tail $tail
}
