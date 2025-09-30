function pbcopy
    # Pipe stdin to base64, then pipe that output to `read`.
    # `read -l` reads one line (the base64 output) into the variable.
    base64 -w0 | read -l b64_data

    # *After* the pipe is closed, `printf` runs
    # as a separate command.
    printf "\e]52;c;%s\a" $b64_data
end
