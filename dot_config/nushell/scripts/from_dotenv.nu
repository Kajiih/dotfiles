# Taken from: https://github.com/nushell/nu_scripts/blob/765555beddc3c81555e6b70abb2542c37a1c0ad6/modules/formats/from-env.nu

# Converts a .env file into a record
# may be used like this: open .env | load-env
# works with quoted and unquoted .env files
def "from env" []: string -> record {
    lines
    | split column '#' # remove comments
    | get column1
    | parse "{key}={value}"
    | update value {
        str trim # Trim whitespace between value and inline comments
        | str trim -c '"' # unquote double-quoted values
        | str trim -c "'" # unquote single-quoted values
        | str replace -a "\\n" "\n" # replace `\n` with newline char
        | str replace -a "\\r" "\r" # replace `\r` with carriage return
        | str replace -a "\\t" "\t" # replace `\t` with tab
    }
    | transpose -r -d
}
