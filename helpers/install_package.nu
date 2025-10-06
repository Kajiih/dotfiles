# File: scripts/helper.nu

# Helper to execute a command list
# Returns the manager name string on SUCCESS, or null on failure.
def run-and-print [name: string, manager: string, cmd_list: list<string>] {
    try {
        ($cmd_list | complete)
        print (ansi green) $"($name) installed with ($manager)." (ansi reset)
        return $manager
    } catch {
        print (ansi red_bold) $"Installing ($name) unexpectedly failed using ($manager)." (ansi reset)
        return null
    }
}


export def install-package [
    name: string
    packages: record
    # Command to check for existence to know whether the package is already installed
    --check-cmd: string = ""
] {
    let final_check_cmd = if ($check_cmd | is-not-empty) { $check_cmd } else { $name } 
    # Check if the tool is already installed
    if (which $final_check_cmd | is-not-empty) {
        print $"($name) already installed at (which $final_check_cmd | get path). Skipping."
        return null
    }

    # Install
    print (ansi attr_bold) ($"Installing ($name):" | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)
    
    let brew_pkg = ($packages | get brew | default null)
    if (which brew | is-not-empty and ($brew_pkg | is-not-null)) {
        return (run-and-print $name "Homebrew" ["brew", "install", $brew_pkg])
    } 
    
    let apt_pkg = ($packages | get apt | default null)
    else if (which apt | is-not-empty and ($apt_pkg | is-not-null)) {
        return (run-and-print $name "apt" ["sudo", "apt", "install", $apt_pkg])
    } 
    
    let cargo_pkg = ($packages | get cargo | default null)
    else if (which cargo | is-not-empty and which binstall | is-not-empty and ($cargo_pkg | is-not-null)) {
        return (run-and-print $name "cargo binstall" ["cargo", "binstall", "--no-confirm", $cargo_pkg])
    }
    
    let uv_pkg = ($packages | get uv | default null)
    else if (which uv | is-not-empty and ($uv_pkg | is-not-null)) {
        return (run-and-print $name "uv tool" ["uv", "tool", "install", $uv_pkg])
    }
    
    # Fallback
    else {
        print (ansi yellow_bold) $"Skipping ($name) installation: No supported package manager found." (ansi reset)
        return null
    }
}
