source ~/.local/share/chezmoi/helpers/theme.nu

# Helper to execute a command list
def run-and-print [name: string, manager: string, cmd_list: list<string>] {
    try {
        ($cmd_list | complete)
        print-success $"($name) installed with ($manager)."
        return $manager
    } catch {
        print-error $"Installing ($name) unexpectedly failed using ($manager)."
        return null
    }
}


export def install-package [
    name: string
    packages: record
    # Command to check for existence to know whether the package is already installed
    --check-cmd: string = ""
] {
    let final_check_cmd = if ($check_cmd | is-empty) { $name } else { $check_cmd }
    if (which $final_check_cmd | is-not-empty) {
        print-info $"($name) already installed at (which $final_check_cmd | get path | first). Skipping."
        return null
    }

    print-header $"Installing ($name):"

    let managers = [
        { mgr_name: "Homebrew",       check_cmd: "brew",     pkg_key: "brew",  install_cmd: ["brew", "install"] },
        { mgr_name: "apt",            check_cmd: "apt",      pkg_key: "apt",   install_cmd: ["sudo", "apt", "install", "-y"] },
        { mgr_name: "cargo binstall", check_cmd: "binstall", pkg_key: "cargo", install_cmd: ["cargo", "binstall", "--no-confirm"] },
        { mgr_name: "uv tool",        check_cmd: "uv",       pkg_key: "uv",    install_cmd: ["uv", "tool", "install"] }
    ]

    for mgr in $managers {
        let pkg_name = ($packages | get $mgr.pkg_key | default null)
        if ((which $mgr.check_cmd | is-not-empty) and ($pkg_name | is-not-null)) {
            let final_cmd = $mgr.install_cmd | append $pkg_name
            return (run-and-print $name $mgr.mgr_name $final_cmd)
        }
    }
    
    # Fallback
    print-warning $"Skipping ($name) installation: No supported package manager found."
    return null
}
