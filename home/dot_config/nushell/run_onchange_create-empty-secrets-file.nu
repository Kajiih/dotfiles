#!/usr/bin/env nu

if "secrets.nu" not-in (ls | get name) {
    touch secrets.nu
}
