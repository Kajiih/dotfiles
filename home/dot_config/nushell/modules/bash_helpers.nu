# bash_helpers.nu

# --- Core Logic (Exported for Testing) ---

# Internal logic for remove-bash-newlines
export def remove-bash-newlines-logic [raw_command: string] {
    if ($raw_command | is-empty) { return "" }

    # Match a backslash OR any whitespace character (including \n)
    let flattened = ($raw_command 
        | str replace --all --regex '[\\\s]+' ' ' 
        | str trim)

    return $flattened
}

# Internal logic for convert-bash-command
export def convert-bash-command-logic [raw_command: string] {
    if ($raw_command | is-empty) { return "" }

    # 1. Flatten (remove backslashes and collapse whitespace/newlines)
    let flattened = (remove-bash-newlines-logic $raw_command)

    # 2. Replace '&&' with ';'
    let replaced_and = ($flattened | str replace --all '&&' ';')
    
    # 3. Find exports
    let exports = ($replaced_and | parse --regex "export\\s+(?P<key>[A-Za-z_]\\w*)=(?P<value>\"[^\"]*\"|'[^']*'|[^\\s;&]+)")
    
    if ($exports | is-empty) {
        return $replaced_and
    }
    
    # 4. Clean command (remove exports)
    let clean_command = ($replaced_and 
        | str replace --all --regex "export\\s+[A-Za-z_]\\w*=(?:\"[^\"]*\"|'[^']*'|[^\\s;&]+)\\s*[;&]?\\s*" ''
        | str trim)
        
    # 5. Build env record and strip quotes from values
    let env_record = ($exports | reduce --fold {} {|it, acc| 
        let val = ($it.value | str replace --all --regex '^["'']|["'']$' '')
        $acc | insert $it.key $val 
    })
    
    let env_str = ($env_record | to nuon)
    return $"with-env ($env_str) { ($clean_command) }"
}

# --- Top-Level Commands ---

# Remove newlines and backslashes from a pasted command, flattening it into a single line, and copy the result to the clipboard. Useful for pasting multi-line bash commands in nushell.
export def remove-bash-newlines [
    --manual-input (-m) # Manually trigger the command instead of automatically on paste
]: nothing -> nothing {
    let raw_command = (if $manual_input { input-multiline "Paste your command:" } else { paste-from-clipboard } | str trim)
    
    let flattened = (remove-bash-newlines-logic $raw_command)

    if ($flattened | is-empty) { return }
    
    $flattened | copy-to-clipboard
    print "Command copied to clipboard"
}

# Convert a pasted Bash command with `&&` and `export` into a Nushell command using `;` and `with-env`.
export def convert-bash-command [
    --manual-input (-m) # Manually trigger the command instead of automatically on paste
]: nothing -> nothing {
    let raw_command = (if $manual_input { input-multiline "Paste your command:" } else { paste-from-clipboard } | str trim)
    
    let converted = (convert-bash-command-logic $raw_command)
    
    if ($converted | is-empty) { return }
    
    $converted | copy-to-clipboard
    print "Command converted and copied to clipboard"
}


# === Test Cases ===

def run-tests [] {
    use std assert

    print "(ansi yellow)🧪 Starting Bash Helpers Tests...(ansi reset)"

    # === 1. Test remove-bash-newlines-logic ===
    print "   [1] Testing remove-bash-newlines-logic..."
    
    let input_nl = "line1 \\\n line2"
    let res_nl = (remove-bash-newlines-logic $input_nl)
    assert ($res_nl == "line1 line2")

    let input_nl_multi = "line1 \\\n  line2 \\\n line3"
    let res_nl_multi = (remove-bash-newlines-logic $input_nl_multi)
    assert ($res_nl_multi == "line1 line2 line3")

    # === 2. Test convert-bash-command-logic ===
    print "   [2] Testing convert-bash-command-logic..."

    let t1_in = "echo hello && echo world"
    let t1_out = (convert-bash-command-logic $t1_in)
    assert ($t1_out == "echo hello ; echo world")

    let t2_in = "export FOO=bar && echo $FOO"
    let t2_out = (convert-bash-command-logic $t2_in)
    assert ($t2_out == 'with-env {FOO: bar} { echo $FOO }')

    let t3_in = "export FOO=bar && export BAZ=\"hello world\" && echo $FOO $BAZ"
    let t3_out = (convert-bash-command-logic $t3_in)
    assert ($t3_out == 'with-env {FOO: bar, BAZ: "hello world"} { echo $FOO $BAZ }')

    let t4_in = "export FOO=bar; export BAZ='single quotes'; echo $FOO"
    let t4_out = (convert-bash-command-logic $t4_in)
    assert ($t4_out == 'with-env {FOO: bar, BAZ: "single quotes"} { echo $FOO }')

    let t5_in = "ls -la && grep foo"
    let t5_out = (convert-bash-command-logic $t5_in)
    assert ($t5_out == "ls -la ; grep foo")

    print "(ansi green)✅ All tests passed!(ansi reset)"
}
