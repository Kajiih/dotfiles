#!/usr/bin/env nu

use ~/.config/.chezmoi_variables.nu IS_GOOGLE_SPECIFIC

# --- gLinux apps ---
sudo glinux-add-repo gqui
sudo apt update
sudo apt install gqui

# TODO: Add things to add in bash
