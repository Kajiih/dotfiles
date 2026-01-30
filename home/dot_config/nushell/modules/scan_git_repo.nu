# Fuzzy find and visualize git repos on your files system.

use squeeze.nu

# Fuzzy find and visualize git repos on your files system.
export def scan-git-repos [--from-home (-a)]: nothing -> string {
    if $from_home { cd $env.HOME }

    fd -u --type directory --glob '.git' --exclude '/.*'
    | lines
    | each { path dirname }
    | str join "\n"
    # | fzf --preview "tree -C {} --gitignore | head -n 80"
    # | fzf --preview "onefetch {} --type prose programming markup data"
    # | fzf --preview 'nu -c "lz --tree --git-ignore {} | head -n 80"' # TODO: Check why we can't use aliases in fzf preview; can try this: https://github.com/junegunn/fzf/issues/1374
    # | fzf --preview "(try {(onefetch {} --type prose programming markup data --disabled-fields dependencies authors url  churn lines-of-code size license --no-title --no-art --no-color-palette)  + `\n`} catch {''}) + (eza {} --color=always --git --git-ignore --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first --sort=type --sort=name) | head -n 80"  # TODO: Create preview command file
    | fzf --preview "(try {(onefetch {} --type prose programming markup data  --no-title --no-art --no-color-palette --disabled-fields license size pending)} catch {(eza {} --color=always --git --git-ignore --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first --sort=type --sort=name --tree --level 3) | head -n 80}) " # TODO: Create preview command file
}
