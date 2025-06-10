# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options

use std "path add"

const NU_COMPLETIONS_DIR = $nu.default-config-dir | path join completions
const NU_LIB_DIRS = [$NU_COMPLETIONS_DIR ($nu.default-config-dir | path join modules) ($nu.default-config-dir | path join submodules) ...$NU_LIB_DIRS]

# TODO:
# Move completers, omnihelp, resolve alias etc in a single utils module
# File issue on https://github.com/blindFS/topiary-nushell to break long lists, pipelines, etc

# === Env Vars ===

# --- Package Manager Binaries --- 
# https://reimbar.org/dev/nushell/
path add [
    "/opt/homebrew/bin" # Homebrew binaries
    "~/.cargo/bin" # Cargo binaries
    "/opt/homebrew/opt/uutils-coreutils/libexec/uubin" # uutils-coreutils binaries
]

# --- Secrets ---
# TODO: Research secret zero/first secret to solve the problem of the first secret
use bws_secrets.nu; bws_secrets load-all

# --- My Info ---
$env.EMAIL = "itskajih@gmail.com"
$env.USERNAME = "Kajih"

# --- Other --
$env.SHELL = "nu"
$env.config.buffer_editor = "code"
$env.EDITOR = $env.config.buffer_editor

$env.config.show_banner = false
$env.config.edit_mode = 'vi'
$env.config.rm.always_trash = true

# Disable prompt from Nushell Because it is duplicated with that of Starship
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
# Use cursor shape to differentiate instead
$env.config.cursor_shape.vi_insert = "blink_line"
$env.config.cursor_shape.vi_normal = "blink_block"

# === Plugins ===
const NU_PLUGIN_DIRS = [
    ($nu.current-exe | path dirname) # Core plugins in the same directory as nu's executable
    ~/.cargo/bin # 3rd party plugins
    ...$NU_PLUGIN_DIRS
]

# --- NUPM --- # Currently unstable # TODO: Check when stable
# # $env.NUPM_HOME = ($env.XDG_DATA_HOME | path join "nupm")
# $env.NUPM_HOME = "~/Library/Application Support/nushell/nupm" # TODO: Check if we keep that path
# $env.NU_LIB_DIRS = ($env.NUPM_HOME | path join "modules")
# path add ($env.NUPM_HOME | path join "scripts")

# --- PostgresQL ---  # TODO: Setup Postgres
# https://gitlab.com/HertelP/nu_plugin_nupsql
$env.config.plugins.nupsql.databases = [
    {
        # The name that is used to query the database (nuql query **name** query)
        host: localhost
        # Necessary connection information (except the password) 
        db: database
        user: postgres
        # Optional query alias to avoid typing often used statements
        query_alias: [
            {
                name: users
                query: "SELECT * FROM users;"
            }
        ]
    }
]

# === Tools ===
# --- Builtins ---
source init/custom_ls.nu
alias ll = ls -l
alias lsa = ls -a

# ls with filter by name ~= s
def lsf [s: string] {
    lsa | where name =~ $s
}

alias o = open

# --- Customs ---
# source omnihelp.nu
use omnihelp.nu
alias h = omnihelp

use resolve_alias_chain.nu resolve-alias-chain

# -- open --
# https://www.nushell.sh/book/configuration.html#macos-keeping-usr-bin-open-as-open
# alias nu-open = open

#  --- Starship --
mkdir ($nu.data-dir | path join vendor/autoload)
starship init nu | save -f ($nu.data-dir | path join vendor/autoload/starship.nu)

# --- Carapace ---
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# https://carapace-sh.github.io/carapace-bin/setup.html
source ~/.cache/carapace/init.nu

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# --- atuin ---
source ~/.local/share/atuin/init.nu

# --- Bat ---
# TODO? Install Nushell completion: https://gist.github.com/melMass/294c21a113d0bd329ae935a79879fe04 

# Use bat on man output
alias man = batman

alias b = bat
alias bh = bat --plain --language=help
alias bn = bat --number
alias bnl = bat --number --line-range
alias bp = bat --plain
alias bpl = bat --plain --line-range
alias bl = bat --line-range

# --- fd ---

# Preview fd results with bat
def fdx [s] {
    fd $s -X bat
}

# --- fzf ---
$env.FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git"
# alias fzf = fzf 
# Preview fzf result with bat
alias fzp = fzf --preview "bat --color=always --style=plain --line-range=:500 {}"

let fg = "#CBE0F0"
let bg = "#011628"
let bg_highlight = "#143652"
let purple = "#b192c9"
let blue = "#6cb6cd"
let cyan = "#2CF9ED"

$env.FZF_DEFAULT_OPTS = $" --color=,hl:($purple),hl+:($blue),prompt:($purple),pointer:($blue),marker:($cyan),spinner:($cyan),header:($cyan)" #fg:($fg),fg+:($fg),bg:($bg),info:($blue)bg+:($bg_highlight),

# Import the FZF keybindings module
source init/fzf_keybindings.nu

# --- Zoxide --- Keep at the end 
zoxide init nushell | save -f ~/.zoxide.nu

# z to fuzzy cd
# zi to interactive cd with fzf
# https://github.com/ajeetdsouza/zoxide#configuration
source ~/.zoxide.nu

let zoxide_completer = {|spans: list<string>|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD }
}

# --- Eza (better ls) ----

alias lz = eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions --group-directories-first --sort=type --sort=name
alias lza = lz -a
alias lzt = lz --tree --level=2
alias lztt = lz --tree
alias lzr = lz --recurse --level=2
alias lzrr = lz --recurse

# --- thefuck ---
# Workaround because repo is kinda dead: https://github.com/nvbn/thefuck/issues/1254
def f [] {
    with-env {TF_ALIAS: "f" PYTHONIOENCODING: "utf-8"} {
        let cmd = thefuck (history | last 1 | get command.0)
        if ($cmd | is-not-empty) {
            nu -c $cmd
        }
    }
}

# --- ripgrep ---
$env.RIPGREP_CONFIG_PATH = $env.XDG_CONFIG_HOME | path join ripgrep config.sh
alias ripgrep = rg
alias rg = batgrep
alias rgi = rg -i
alias rga = rg -uuu
# def rgf [...arg]
# alias rgf = ripgrep --files | ripgrep
alias rgc = ripgrep --count

# Search in files found by ripgrep
def rgf [pattern: string ...rest] {
    ripgrep --files | ripgrep $pattern ...$rest
}

# --- Git ---
alias gs = git status
alias gll = git log --graph --all --pretty="format:%C(yellow)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"
alias gl = gl --oneline
alias gui = gitui

# --- Chezmoi ---
$env.DOTFILES_DIR = (chezmoi source-path | path dirname)
alias ch = chezmoi
alias ched = code $env.DOTFILES_DIR
alias chad = ch add
alias chap = ch apply
alias chd = ch diff
alias chs = ch status
alias chdr = ch doctor

$env.HOMEBREW_BUNDLE_FILE = $env.XDG_CONFIG_HOME | path join homebrew Brewfile

# --- OCR with tesseract ---
alias ocr = tesseract

# --- Topiary Nushell formatter ---
$env.TOPIARY_LANGUAGE_DIR = $env.XDG_CONFIG_HOME | path join topiary languages
$env.TOPIARY_CONFIG_FILE = $env.XDG_CONFIG_HOME | path join topiary languages.ncl

# For vscode extension:
# Check https://code.visualstudio.com/docs/supporting/faq#_resolving-shell-environment-fails and https://stackoverflow.com/questions/48595446/is-there-any-way-to-set-environment-variables-in-visual-studio-code to see if it's possible to source environment from nushell
# Apparently it's necessarily sourcing the env from then $SHELL defined in chsh: https://github.com/microsoft/vscode/issues/205321#issuecomment-1954415144
# Does this indeed mean that it sources necessarily from the login shell: https://code.visualstudio.com/docs/terminal/profiles#_why-are-there-duplicate-paths-in-the-terminals-path-environment-variable-andor-why-are-they-reversed-on-macos
# Track https://github.com/constneo/vscode-nushell-format/issues/1 for issue with space in command | path basename

# --- hyperfine ---

alias hyperfine = hyperfine --shell=nu
# TODO: Make it work on nu aliases, modules etc e.g. 
# hyperfine "bws_secrets get-token"
# hyperfine "lz"

# --- bandwhich ---

alias bandwhich = sudo bandwhich

# --- bottom ---

alias btm = btm --battery # wtf doesn't this work???

# --- grex ---

alias grex = grex --colorize

# --- Yazi ---
# y to open yazi, then q to quit and change CWD, or Q to quit without changing

# https://yazi-rs.github.io/docs/configuration/overview
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

def --env zy [...args] {
    zi
    y
}

# --- onefetch ---
alias onefetch = onefetch --nerd-fonts --no-color-palette
# Short version showing only high level info
alias onefetch-s = onefetch --disabled-fields dependencies authors contributors url commits churn lines-of-code size license --no-title --no-art
# expensive fields (given some tiny benchmarks with cache warmup):
# - pending
# - license
# - size
# also: 
# - title

# --- Custom utils ---

# A smarter head command that preserves colors and shows truncation indicators
def better-head [
    --lines: int = 10 # Number of lines to show (default: 10)
    --indicator: string = "..." # Truncation indicator
    --context: int = 0 # Additional context lines to show after indicator
]: nothing -> string {
    let input = $in
    let colored_lines = ($input | ansi strip | lines | length)
    let all_lines = ($input | lines)

    if ($all_lines | length) <= $lines {
        $input # Return original input if within limit
    } else {
        # Preserve colors in output
        let output = ($all_lines | first $lines | str join "\n")
        let remaining = (($all_lines | length) - $lines)

        # Build indicator with context
        let indicator = if $context > 0 {
            [
                $indicator
                ($all_lines | last $context | str join "\n")
                $"($remaining) more lines"
            ] | str join "\n"
        } else {
            $"($indicator) ($remaining) more lines"
        }

        # Return colored output with indicator
        [$output $indicator] | str join "\n"
    }
}

# Updated git-status-short using better-head
def git-status-short [] {
    git -c color.ui=always status | better-head --lines 7 --context 2
}

def --env fzg [ --from-home (-a)] {
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
    | cd $in
    # | cd ($base_dir | path join $in)  # TODO: Report that produces a weir behavior in the shell after that

    onefetch --type prose programming markup data
    git-status-short
    # gitui
    # return gstat  # Check why we can't use plugins here
    # return  # early return to stop fd
}

# --- zellij ---
alias zj = zellij

# --- Copier ---
$env.COPIER_SETTINGS_PATH = $env.XDG_CONFIG_HOME | path join copier settings.yml

# === Completions ===
# TODO: Check if it's possible to autoload completion modules using $nu.user_autoload_dirs
use completions *
# Update the completions module exporting every module inside $NU_COMPLETIONS_DIR
# To use after adding completions
def update_completions_module [] {
    let module_path = ($NU_COMPLETIONS_DIR | path join mod.nu)
    rm $module_path --force

    ls $NU_COMPLETIONS_DIR
    | where name ends-with ".nu"
    | get name
    | each {|file| $"export use ($file | path basename) *" }
    | str join "\n"
    | save $module_path -f
}

# --- External Completers --
# https://www.nushell.sh/cookbook/external_completers.html#putting-it-all-together

let fish_completer = {|spans: list<string>|
    fish --command $"complete '--do-complete=($spans | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {
        if ($in | path exists) { $'"($in | str replace "\"" "\\\"")"' } else { $in }
    }
}

# let chain = resolve-alias-chain $spans.0
# let expanded_alias = $chain | last
# print $expanded_alias

# This completer will use carapace by default
# TODO: Remove already used flags? -> already the case it seems
let external_completer = {|spans: list<string>|
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

# Update config
$env.config.completions.external = {
    enable: true
    completer: $external_completer
}

# === Theming ===
# https://www.nushell.sh/book/coloring_and_theming.html#understanding-ls-colors

# --- LS Colors ---
# Using Vivid: https://github.com/sharkdp/vivid
# $env.LS_COLORS = (vivid generate ayu)

# Auto imported from https://github.com/trapd00r/LS_COLORS
let ls_colors_file = $nu.default-config-dir | path join data lscolors.sh
$env.LS_COLORS = open $ls_colors_file | str substring 11..-20

# === Keybindings ===
# https://www.nushell.sh/book/line_editor.html#keybindings
$env.config.keybindings ++= [
    # TODO: Check why it doesn't work with any Shift + Enter | Cmd + Enter ... (file issue)
    # {
    #     name: insert_newline_shift
    #     modifier: Shift
    #     keycode: Enter
    #     mode: [vi_insert vi_normal]
    #     event: { edit: InsertNewline }
    # }
    {
        name: abbr
        modifier: control
        keycode: space
        mode: [emacs vi_normal vi_insert]
        event: [
            {send: menu name: abbr_menu}
            {edit: insertchar value: ' '}
        ]
    }
]

$env.config.menus ++= [
    {
        name: abbr_menu
        only_buffer_difference: false
        marker: "👀 "
        type: {
            layout: columnar
            columns: 1
            col_width: 20
            col_padding: 2
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: {|buffer position|
            scope aliases
            | where name == $buffer
            | each {|elt| {value: $elt.expansion} }
        }
    }
]
