use ~/.local/share/chezmoi/helpers/theme.nu [ print-header print-success print-error print-info print-warning ]

export def install-package [
    name: string
    --brew: string = ""
    --cask: string = ""
    --apt: string = ""
    --cargo: string = ""
    --uv: string = ""
    --check-installed: string = ""
] {
    let final_check_installed = if ($check_installed | is-empty) { $name } else { $check_installed }
    if (which $final_check_installed | is-not-empty) {
        print-info $"($name) already installed at (which $final_check_installed | get path | first). Skipping."
        return null
    }
    # We can check installed apps with `mdfind "kMDItemKind == 'Application'"` 
    # See: https://stackoverflow.com/questions/54100496/check-if-an-app-is-installed-on-macos-using-the-terminal
    # TODO? Remove already installed check altogether?

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
        }
    }

    # CHECK B: Block simultaneous '--brew' and '--cask'
    if $brew_present and $cask_present {
        error make {
            msg: $"Package ($name) cannot be defined with both '--brew' (Formula) and '--cask' (Application) flags."
        }
    }
    # ---------------------------------------------------

    print-header $"Installing ($name):"

    let managers = [
        {name: "Homebrew" check_installed: "brew" package: $brew install_command: ["brew" "install"]}
        {name: "Homebrew (Cask)" check_installed: "brew" package: $cask install_command: ["brew" "install" "--cask"]}
        {name: "apt" check_installed: "apt" package: $apt install_command: ["sudo" "apt" "install" "-y"]} # TODO: Check that it works
        {name: "cargo binstall" check_installed: "cargo-binstall" package: $cargo install_command: ["cargo" "binstall" "--no-confirm"]}
        {name: "uv tool" check_installed: "uv" package: $uv install_command: ["uv" "tool" "install"]}
    ]

    # --- 2. Installation Logic ---
    for manager in $managers {
        let package = $manager.package

        if ((which $manager.check_installed | is-not-empty) and ($package | is-not-empty)) {
            let command = $manager.install_command | append $package
            ^$"($command | first)" ...($command|skip 1)
            return $manager.name
        }
    }

    # --- 3. Could not be installed ---
    error make {
        msg: $"Could not install ($name): no supported package manager is available on this system."
    }
}
