# Store builtin ls as ls-builtin and use a custom ls with sorting by type and name
# Taken from: https://github.com/nushell/nushell/issues/7190#issuecomment-2676237144

# alias the built in ls command so we don't shadow it
alias ls-builtin = ls

# List the filenames, sizes, and modification times of items in a directory.
@category filesystem
@search-terms dir
@example "List the files in the current directory" { ls }
@example "List visible files in a subdirectory" { ls subdir }
@example "List visible files with full path in the parent directory" { ls -f .. }
@example "List Rust files" { ls *.rs }
@example "List files and directories whose name do not contain 'bar'" { ls | where name !~ bar }
@example "List the full path of all dirs in your home directory" { ls -a ~ | where type == dir }
@example "List only the names (not paths) of all dirs in your home directory which have not been modified in 7 days" { ls -as ~ | where type == dir and modified < ((date now) - 7day) }
@example "Recursively list all files and subdirectories under the current directory using a glob pattern" { ls -a **/* }
export def ls [
    --all (-a) # Show hidden files
    --long (-l) # Get all available columns for each entry (slower; columns are platform-dependent)
    --short-names (-s) # Only print the file names, and not the path
    --full-paths (-f) # display paths as absolute paths
    --du (-d) # Display the apparent directory size ("disk usage") in place of the directory metadata size
    --directory (-D) # List the specified directory itself instead of its contents
    --mime-type (-m) # Show mime-type in type column instead of 'file' (based on filenames only; files' contents are not examined)
    --threads (-t) # Use multiple threads to list contents. Output will be non-deterministic.
    ...pattern: glob # The glob pattern to use.
]: [nothing -> table] {
    let pattern = if ($pattern | is-empty) { ['.'] } else { $pattern }
    (
        ls-builtin
        --all=$all
        --long=$long
        --short-names=$short_names
        --full-paths=$full_paths
        --du=$du
        --directory=$directory
        --mime-type=$mime_type
        --threads=$threads
        ...$pattern
    ) | sort-by type name -i
}

# @example "Recursively list *.rs and *.toml files using the glob command" { ls ...(glob **/*.{rs,toml}) }
# @example "List given paths and show directories themselves" { ['/path/to/directory' '/path/to/file'] | each {|| ls -D $in } | flatten }
