#!/usr/bin/env nu

use ~/.config/.chezmoi_variables.nu [ IS_GOOGLE_SPECIFIC SCHEDULED_MAINTENANCE_DATE_TIME ]
use ~/.local/share/chezmoi/helpers/theme.nu [ print-header print-info print-warning print-success ]

if not $IS_GOOGLE_SPECIFIC {
    exit
}

# === gLinux apps ===
sudo glinux-add-repo gqui
sudo apt update
sudo apt install gqui

# === Add nushell startup to .bashrc ===
print-info "
Configuring .bashrc to launch nu shell for interactive sessions..." 

let bashrc_file = ("~/.bashrc" | path expand)
let dot_bash_nu_startup_file = ("~/.config/nushell/.bash_nu_startup.sh" | path expand)

let message_to_check = "# === Source nu startup file === DON'T MODIFY THIS COMMENT"

if (open $bashrc_file | grep $message_to_check | is-not-empty) {
    print-info "Nushell already setup, nothing was done."
} else {
    $"
    ($message_to_check)
    . ($dot_bash_nu_startup_file)
    " | save --append $bashrc_file
    print-success $"Nushell startup snippet added to ($bashrc_file). Please start a new shell session."
}


# === Cloudtop maintenance schedule === 
print-info $"
To schedule maintenance at 4 AM (CET): ctop self maintenance schedule at ($SCHEDULED_MAINTENANCE_DATE_TIME)"


# === Ghostty ssh Terminfo (on cloudtop) === 
# https://ghostty.org/docs/help/terminfo#copy-ghostty's-terminfo-to-a-remote-machine
# TODO: P0 - Add check to see whether xterm-ghostty terminfo is installed
# Check if the 'xterm-ghostty' terminfo is installed
let ghostty_terminfo_installed = (infocmp -x xterm-ghostty | complete).exit_code == 0

# Only show the warning if the command failed (exit_code != 0)
if not $ghostty_terminfo_installed {
  print-warning "
  --------------------------------------------------------------------------
  ACTION REQUIRED for Ghostty Terminal users:

  If you use Ghostty on your local machine to SSH to this machine,
  install the 'xterm-ghostty' terminfo to prevent errors later.

  Run this command from YOUR LOCAL MACHINE (e.g., Ombrecoeur):"

  print-info $"infocmp -x xterm-ghostty | ssh (hostname) -- 'mkdir -p ~/.terminfo && tic -x -'"

  print-warning "This copies Ghostty's terminfo entry to the remote machine.
  More info: https://ghostty.site/docs/help/terminfo/
  --------------------------------------------------------------------------"
}
