# Adapted from: https://github.com/junegunn/fzf/issues/4122
$env.config.keybindings ++= [
    {
        name: fzf_dirs
        modifier: control
        keycode: char_s
        mode: [emacs vi_normal vi_insert]
        event: {
            send: executehostcommand
            cmd: "cd (fd --type directory --hidden | fzf --preview 'tree -C {} | head -n 200')"
        }
    }
    {
        name: history_menu
        modifier: control
        keycode: char_r
        mode: [emacs vi_insert vi_normal]
        event: {
            send: executehostcommand
            cmd: `commandline edit --insert (
                history 
                | get command 
                | str replace --all (char newline) ' ' 
                | to text 
                | fzf --preview "echo {} | bat --color=always --language=nu --style=plain"
            )`
        }
    }
    {
        name: fzf_files
        modifier: control
        keycode: char_t
        mode: [emacs vi_normal vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit --insert (fd --type file --hidden | fzf --preview 'bat --color=always --style=plain --line-range=:500 {}')"
        }
    }
]
