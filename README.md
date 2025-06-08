# KJ's dotfiles

## Usage

### Setting up new machine

TODO
<https://www.chezmoi.io/user-guide/daily-operations/#install-chezmoi-and-your-dotfiles-on-a-new-machine-with-a-single-command>

### Using `Chezmoi`

-

## Roadmap

- [ ] Use externals for LS_COLORS

- [WIP] Cross platform
  - [ ] Windows
  - [WIP] Mac (homebrew)
  - [ ] Linux

- [WIP] Chezmoi setup

## Features

- Managed with [Chezmoi](https://www.chezmoi.io/)****
- [Nushell](https://www.nushell.sh/) as login shell

- `XDG_CONFIG_HOME` and `XDG_DATA_HOME` set on all platforms

  - [MacOS](https://github.com/nushell/nushell/discussions/14663#discussioncomment-11876260): `/Users/<user_name>/Launchagents/<whatever>.plis` (don't use comments, it doesn't work):

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>

    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>my.startup.shell_agnostic.environment</string>
        <key>ProgramArguments</key>
        <array>
            <string>/bin/sh</string>
            <string>-c</string>
            <string>
                launchctl setenv XDG_CONFIG_HOME /Users/julian/.config
                && XDG_DATA_HOME /Users/julian/.local/share
            </string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ServiceIPC</key>
        <false/>
    </dict>
    </plist>
    ```

- Secret loading with `bitwarden secrets`
  - MacOS: Token access in `keychain`. To add the access token:

    ```nu
    security add-generic-password -a $env.USER -s bws_token -w <access_token>
    ```
