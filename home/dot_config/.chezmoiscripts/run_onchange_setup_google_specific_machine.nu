#!/usr/bin/env nu

use ~/.config/.chezmoi_variables.nu IS_GOOGLE_SPECIFIC
use ~/.local/share/chezmoi/helpers/theme.nu [ print-header print-info print-warning print-success ]

# === gLinux apps ===
sudo glinux-add-repo gqui
sudo apt update
sudo apt install gqui

# === Add nushell startup to .bashrc ===
print-info "
Setting up nu shell...
Configuring .bashrc to launch nu shell for interactive sessions..." 

let bashrc_file = "~/.bashrc"
let dot_bash_nu_startup_file = ~/.config/nushell/.bash_nu_startup.sh

let message_to_check = "# === Source nu startup file === DON'T MODIFY THIS COMMENT"

if (open $bashrc_file | grep $message_to_check | is-not-empty) {
    print-info "Nushell already setup, nothing was done."
} else {
    $"
    ($message_to_check)
    . ($dot_bash_nu_startup_file)
    " | save --append $bashrc_file
    print-success "Nushell was successfully setup."
}


# === Cloudtop maintenance schedule === 
ctop self maintenance schedule at "{{ now | dateModify "+27d" | date "2006-01-02" }} 02:00:00" 


# === Ghostty ssh Terminfo (on cloudtop) === 
# https://ghostty.org/docs/help/terminfo#copy-ghostty's-terminfo-to-a-remote-machine 
print-info $"
--------------------------------------------------------------------------
ACTION REQUIRED for Ghostty Terminal Users:

If you use Ghostty on your local machine to SSH to this machine,
install the 'xterm-ghostty' terminfo to prevent errors later.

Run this command from YOUR LOCAL MACHINE \(e.g., Ombrecoeur\):

infocmp -x xterm-ghostty | ssh (hostname) -- 'mkdir -p ~/.terminfo && tic -x -'

This copies Ghostty's terminfo entry to the remote machine.
More info: https://ghostty.site/docs/help/terminfo/
--------------------------------------------------------------------------"


# === Manual Installation Reminder ===
print-warning "
--------------------------------------------------------------------------
IMPORTANT: Remember to install go/aae-toolbox if you need it.
--------------------------------------------------------------------------"
