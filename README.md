# KJ's dotfiles

## Usage

Cross platform tools managed by cross platforms package managers, at least in theory..!

⚠️ **This repo is only teste for SOME config, not a full machine setup from scratch, and only on MacOS (specifically my Mac M2 laptop), so it will have to be fine tuned for other systems and architectures with time. Only some files contain templates that separate Mac specific config to platform agnostic config.**

### Setting up new machine

#### TODOs, look [chezmoi's doc](https://www.chezmoi.io/user-guide/daily-operations/#install-chezmoi-and-your-dotfiles-on-a-new-machine-with-a-single-command)

- Install [`chezmoi`](https://www.chezmoi.io/install/) and probably [`nushell`](https://www.nushell.sh/book/installation.html)
  - Probably set `nushell` as login shell
- Install package managers
  - ⚠️ Brewfile install script is not written yet
- Setup secrets (e.g. with keychain on mac, etc)
- Setup [things that have yet to be setup manually](/docs/thing-to-setup-manually.md)
- and more

### Using `Chezmoi`

- `update` to sync local dotfiles with remote repo
- `apply` to sync local dotfiles with local repo (source)
  - also `diff` to see what changes would be made
- `edit $FILE` to edit the file in the local repo (but not the real file until apply)
  - More [info](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/#how-do-i-edit-my-dotfiles-with-chezmoi)
- `merge $FILE` to merge changes to real file with source on local repo
- `git commit` and `git push` to sync with remote
  - More [info](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/#once-ive-made-a-change-to-the-source-directory-how-do-i-commit-it)
- `status`, `managed`, `unmanaged`: useful to get info

## Roadmap

- [WIP] Cross platform
  - [ ] Windows
  - [WIP] Mac
  - [ ] Linux
  - Settings (currently based on Mac)
  - [ ] Key repeat rate
  - [ ] Delay after repeat
  - [ ] Press and hold key (for accent)
    - `defaults write -g ApplePressAndHoldEnabled -bool false`

## Features

- Managed with [Chezmoi](https://www.chezmoi.io/)
- [Nushell](https://www.nushell.sh/) as login shell
- [Ghostty](https://ghostty.org/) as terminal emulator
- [Firefox](https://www.mozilla.org/en-US/firefox/new/) as main browser

- Secret loading with `bitwarden secrets`
  - MacOS: Token access in `keychain`. To add the [access token of your machine account](https://vault.bitwarden.eu/#/sm/6e2de25d-081c-40c1-ab1e-b1f700e89888/projects/f2a257f6-7179-4f88-9c77-b2ee01342082/machine-accounts):

    ```nu
    security add-generic-password -a $env.USER -s bws_token -w <access_token>
    ```

- Cross platform package managers (MacOs, Linux, WSL) by order of precedence:
  - [Homebrew](/dot_config/homebrew/Brewfile)
  - [Cargo](/.chezmoiscripts/run_onchange_install-cargo-bins.nu)
  - [uv tool](https://docs.astral.sh/uv/concepts/tools/)

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

## Thinking about adding

- [Gemini CLI](https://github.com/google-gemini/gemini-cli)

## Resources

- [Reference repo](https://github.com/twpayne/dotfiles/tree/master)
