#!/usr/bin/env nu

# TODO: P1: Implement install from git and use install helpers
if (which clippy | is-empty) { 
    git clone https://github.com/nedn/clippy
}
