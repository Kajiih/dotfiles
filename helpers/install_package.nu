use ~/.local/share/chezmoi/helpers/theme.nu [ print-header print-success print-error print-info print-warning ]

# Helper to execute a command list
def run-and-print [name: string manager: string cmd_list: list<string>] {
    try {
        ($cmd_list | complete) # TODO: Fix this for casks
        print-success $"($name) installed with ($manager)."
        return $manager
    } catch {|err|
        # This catch block only affects run-and-print; we'll let the calling script handle the exit status
        print-error $"Installing ($name) unexpectedly failed using ($manager)."
        print $err.msg
        return null
    }
}

export def install-package [
    name: string
    --brew: string = ""
    --cask: string = ""
    --apt: string = ""
    --cargo: string = ""
    --uv: string = ""
    --check-cmd: string = ""
] {
    let final_check_cmd = if ($check_cmd | is-empty) { $name } else { $check_cmd }
    if (which $final_check_cmd | is-not-empty) {
        print-info $"($name) already installed at (which $final_check_cmd | get path | first). Skipping."
        return null
    }

    # --- 1. Robustness Checks (Force Exit 1 on failure) ---

    let brew_present = ($brew | is-not-empty)
    let cask_present = ($cask | is-not-empty)
    let apt_present = ($apt | is-not-empty)
    let cargo_present = ($cargo | is-not-empty)
    let uv_present = ($uv | is-not-empty)

    # CHECK A: At least one package manager must be defined
    if not ($brew_present or $cask_present or $apt_present or $cargo_present or $uv_present) {
        error make {
            msg: $"No package manager flag was defined for package ($name)."
            exit_code: 1 # TODO: Check if we need to keep this exit code
        }
    }

    # CHECK B: Block simultaneous '--brew' and '--cask'
    if $brew_present and $cask_present {
        error make {
            msg: $"Package ($name) cannot be defined with both '--brew' (Formula) and '--cask' (Application) flags."
            exit_code: 1 # TODO: Check if we need to keep this exit code
        }
    }
    # ---------------------------------------------------

    print-header $"Installing ($name):"

    let managers = [
        {mgr_name: "Homebrew" check_cmd: "brew" pkg_name: $brew install_cmd: ["brew" "install"]}
        {mgr_name: "Homebrew (Cask)" check_cmd: "brew" pkg_name: $cask install_cmd: ["brew" "install" "--cask"]}
        {mgr_name: "apt" check_cmd: "apt" pkg_name: $apt install_cmd: ["sudo" "apt" "install" "-y"]}
        {mgr_name: "cargo binstall" check_cmd: "binstall" pkg_name: $cargo install_cmd: ["cargo" "binstall" "--no-confirm"]}
        {mgr_name: "uv tool" check_cmd: "uv" pkg_name: $uv install_cmd: ["uv" "tool" "install"]}
    ]

    # --- 2. Installation Logic ---

    for mgr in $managers {
        let pkg_name = $mgr.pkg_name

        if ((which $mgr.check_cmd | is-not-empty) and ($pkg_name | is-not-empty)) {
            let final_cmd = $mgr.install_cmd | append $pkg_name
            return (run-and-print $name $mgr.mgr_name $final_cmd)
        }
    }

    # --- 3. Final Fallback ---
    # This is a soft failure (manager not found/available), not a configuration error, 
    # so we return null and let the script continue.
    print-warning $"Skipping ($name) installation: Package defined, but no supported package manager is available on this system."
    return null # TODO: Change to an error
}
