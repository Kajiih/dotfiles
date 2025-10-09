#!/usr/bin/env nu
use ~/.local/share/chezmoi/helpers/theme.nu print-info
use ~/.local/share/chezmoi/helpers/install_package.nu install-package
use ~/.config/.chezmoi_variables.nu [ DEVICE_USAGE IS_GOOGLE_SPECIFIC ]

if (which brew | is-empty) {
    print-info "Homebrew is not installed. Skipping Homebrew packages"
    exit 0
}

# === Define package lists ===
# --- Everywhere ---
let brews = [
    "carapace"
    "eza"
    "fzf"
    "fd"
    "zoxide"
    "cargo-binstall"
    "zellij"
    "uv"
]
let casks = [
    "font-fira-code-nerd-font"
    "raycast"
    "visual-studio-code"
    # "bitwarden" - Install from Mac App Store until the homebrew version is compatible with the browser extension
    "todoist-app"
    "google-drive"
]
# --- Personal ---
let personal_only_brews = [
    "mas"
    "uutils-coreutils"
    "tealdeer"
    "hyperfine"
    "bandwhich"
    "dust"
    "bottom"
    "onefetch"
    "grex"
    "tesseract"
    "tesseract-lang"
    "imageoptim-cli"
    "pandoc"
]
let personal_only_casks = [
    "font-inter"
    "imageoptim"
    "firefox"
    "mozeidon-macos-ui"
    "docker"
    "musescore"
]
# --- Professional ---
let professional_only_brews = []
let professional_only_casks = []

# --- Google Specific ---
# Packages for devices that are not google specific
let non_google_specific_only_brews = [
    "python"
    "ruff"
    "bitwarden-cli"
    "gemini-cli"
]
let google_specific_only_brews = []

# === Select which packages to install based on usage ===
let brews_to_install = $brews ++ (if $DEVICE_USAGE == "personal" { $personal_only_brews } else { $professional_only_brews }) ++ (if $IS_GOOGLE_SPECIFIC { $google_specific_only_brews } else { $non_google_specific_only_brews })
let casks_to_install = if $DEVICE_USAGE == "personal" { $casks ++ $personal_only_casks } else { $casks ++ $professional_only_casks }

# === Install ===
if $DEVICE_USAGE == "professional" {
    $env.HOMEBREW_NO_AUTO_UPDATE = 1
}

for brew in $brews_to_install {
    install-package $brew --brew $brew
}
# Cask only for macOS
if (sys host | get name) == "Darwin" {
    for cask in $casks_to_install {
        install-package $cask --cask $cask
    }
}
