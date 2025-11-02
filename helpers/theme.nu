# Green for success messages
export def print-success [message: string] {
    let text = $"✔ ($message)\n\n"
    print --no-newline  (ansi green_bold) $message (ansi reset)
}

# Red and bold for error messages
export def print-error [message: string] {
    let text = $"✗ ($message)\n\n"
    print --no-newline  (ansi red_bold) $text (ansi reset)
}

# Orange gradient for warnings
export def print-warning [message: string] {
    let text = $"⚠ ($message)\n\n"
    print --no-newline (ansi attr_bold) ($text | ansi gradient --fgstart '0xffc040' --fgend '0xff8040') (ansi reset)
}

# Cyan for informational messages
export def print-info [message: string] {
    let text = $"($message)\n\n"
    print --no-newline (ansi cyan_bold) $text (ansi reset)
}

# Blue/purple gradient for main installation headers
export def print-header [message: string] {
    print (ansi attr_bold) ($message | ansi gradient --fgstart '0x40c9ff' --fgend '0xe81cff') (ansi reset)
}
