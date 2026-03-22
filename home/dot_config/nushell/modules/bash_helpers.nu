# bash_helpers.nu

# --- Core Logic ---

# Internal helper to retrieve input from string, manual input, or clipboard
def get-input [cmd: string, manual_input: bool] {
    if ($cmd | is-not-empty) { 
        $cmd 
    } else if $manual_input { 
        input-multiline "Paste your command:" 
    } else { 
        paste-from-clipboard
    } | str trim
}
# Internal logic for remove-bash-newlines
def remove-bash-newlines-logic [raw_command: string] {
    if ($raw_command | is-empty) { return "" }

    # Match a backslash OR any whitespace character (including \n)
    let flattened = ($raw_command 
        | str replace --all --regex '[\\\s]+' ' ' 
        | str trim)

    return $flattened
}

# Helper to extract scoped variables at the start of a segment
def extract-scoped-vars [segment: string] {
    let segment = ($segment | str trim)
    if ($segment | is-not-empty) != true { return { vars: {}, cmd: "" } }

    mut seg = $segment
    mut vars_record = {}

    loop {
        let regex = "(?P<key>[A-Za-z_]\\w*)=(?P<value>\"[^\"]*\"|'[^']*'|[^\\s;&]+)\\s*"
        let match = ($seg | parse --regex $"^($regex)")
        
        if ($match | is-empty) {
            break
        }
        
        let key = $match.0.key
        let value = $match.0.value
        let val_clean = ($value | str replace --all --regex '^["'']|["'']$' '')
        
        $vars_record = ($vars_record | insert $key $val_clean)
        $seg = ($seg | str replace --regex $"^($regex)" '' | str trim)
    }

    return { vars: $vars_record, cmd: $seg }
}

# Helper to convert a single command segment
def convert-segment [segment: string] {
    let res = (extract-scoped-vars $segment)
    let vars = $res.vars
    let cleaned_cmd = $res.cmd

    if ($vars | is-empty) {
        return $cleaned_cmd
    }

    if ($cleaned_cmd | is-empty) {
        return "" 
    }

    let env_str = ($vars | to nuon)
    return $"with-env ($env_str) { ($cleaned_cmd) }"
}

# Internal logic for convert-bash-command
def convert-bash-command-logic [raw_command: string] {
    if ($raw_command | is-empty) { return "" }

    # 1. Flatten
    let flattened = (remove-bash-newlines-logic $raw_command)

    # 1.5 Replace $VAR and ${VAR} with $env.VAR
    let with_env_vars = ($flattened | str replace --all --regex '\$\{?([A-Za-z_]\w*)\}?' '$$env.$1')

    # 2. Extract global exports
    let exports = ($with_env_vars | parse --regex "export\\s+(?P<key>[A-Za-z_]\\w*)=(?P<value>\"[^\"]*\"|'[^']*'|[^\\s;&]+)")
    
    let env_record_global = (if ($exports | is-not-empty) {
        $exports | reduce --fold {} {|it, acc| 
            let val = ($it.value | str replace --all --regex '^["'']|["'']$' '')
            $acc | insert $it.key $val 
        }
    } else { {} })

    # 3. Clean exports from command
    let cleaned_exports = ($with_env_vars | str replace --all --regex "export\\s+[A-Za-z_]\\w*=(?:\"[^\"]*\"|'[^']*'|[^\\s;&]+)\\s*(?:&&|[;&])?\\s*" '')

    # 4. Replace && with ;
    let replaced_and = ($cleaned_exports | str replace --all '&&' ';')
    
    # 5. Split by ;
    let segments = ($replaced_and | split row ';')
    
    # 6. Convert each segment
    let converted_segments = ($segments | each {|seg| convert-segment $seg })
    
    # 7. Join
    let joined = ($converted_segments | where {|s| ($s | is-not-empty)} | str join " ; ")
    
    # 8. Wrap with global exports
    if ($env_record_global | is-not-empty) {
        let env_str = ($env_record_global | to nuon)
        return $"with-env ($env_str) { ($joined) }"
    } else {
        return $joined
    }
}

# --- Top-Level Commands ---

# Remove newlines and backslashes from a pasted command, flattening it into a single line, and copy the result to the clipboard. Useful for pasting multi-line bash commands in nushell.
@category clipboard
@search-terms flatten bash paste multi-line
@example "Flatten a command string" { remove-bash-newlines "line1 \\\nline2" }
export def remove-bash-newlines [
    cmd: string = "" # Optional command string (reads from clipboard if omitted)
    --manual-input (-m) # Manually trigger the command instead of automatically on paste
]: nothing -> nothing {
    let raw_command = (get-input $cmd $manual_input)
    
    let flattened = (remove-bash-newlines-logic $raw_command)

    if ($flattened | is-empty) { return }
    
    $flattened | copy-to-clipboard
    print "Command copied to clipboard"
}

# Convert a pasted Bash command with `&&` and `export` into a Nushell command using `;` and `with-env`.
@example "Convert complex multi-line command" { convert-bash-command "export FOO=\"bar\" \\\n  && export BAZ=123 \\\n  && PLAYWRIGHT_HTML_OPEN='never' echo $FOO $BAZ \\\n  && echo \"Done\"" }
@category clipboard
@search-terms converter bash switch with-env
@example "Convert a command string with exports" { convert-bash-command "export A=1 && echo $A" }
@example "Convert complex multi-line command" { convert-bash-command "export FOO=\"bar\" \\\n  && export BAZ=123 \\\n  && PLAYWRIGHT_HTML_OPEN='never' npx playwright test \\\n  && echo \"Done\"" }
export def convert-bash-command [
    cmd: string = "" # Optional command string (reads from clipboard if omitted)
    --manual-input (-m) # Manually trigger the command instead of automatically on paste
]: nothing -> nothing {
    let raw_command = (get-input $cmd $manual_input)
    
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
    assert ($t2_out == 'with-env {FOO: bar} { echo $env.FOO }')

    let t3_in = "export FOO=bar && export BAZ=\"hello world\" && echo $FOO $BAZ"
    let t3_out = (convert-bash-command-logic $t3_in)
    assert ($t3_out == 'with-env {FOO: bar, BAZ: "hello world"} { echo $env.FOO $env.BAZ }')

    let t4_in = "export FOO=bar; export BAZ='single quotes'; echo $FOO"
    let t4_out = (convert-bash-command-logic $t4_in)
    assert ($t4_out == 'with-env {FOO: bar, BAZ: "single quotes"} { echo $env.FOO }')

    let t5_in = "ls -la && grep foo"
    let t5_out = (convert-bash-command-logic $t5_in)
    assert ($t5_out == "ls -la ; grep foo")

    # === 2.1 Test Env Var curly brace syntax ===
    let t9_in = "echo ${BAZ}"
    let t9_out = (convert-bash-command-logic $t9_in)
    assert ($t9_out == 'echo $env.BAZ')

    # === 3. Test Scoped / Mixed Env Variables ===
    print "   [3] Testing Scoped/Mixed Env Variables..."

    let t6_in = "PLAYWRIGHT_HTML_OPEN='never' npx playwright test e2e/items.spec.ts"
    let t6_out = (convert-bash-command-logic $t6_in)
    assert ($t6_out == 'with-env {PLAYWRIGHT_HTML_OPEN: never} { npx playwright test e2e/items.spec.ts }')

    let t7_in = "export A=1 && B=2 command1 && command2"
    let t7_out = (convert-bash-command-logic $t7_in)
    assert ($t7_out == 'with-env {A: "1"} { with-env {B: "2"} { command1 } ; command2 }')

        let t8_in = "export FOO=\"bar\" \\\n  && export BAZ=123 \\\n  && PLAYWRIGHT_HTML_OPEN='never' echo $FOO $BAZ \\\n  && echo \"Done\""
    let t8_out = (convert-bash-command-logic $t8_in)
    assert ($t8_out == 'with-env {FOO: bar, BAZ: "123"} { with-env {PLAYWRIGHT_HTML_OPEN: never} { echo $env.FOO $env.BAZ } ; echo "Done" }')

    print "(ansi green)✅ All tests passed!(ansi reset)"
}
