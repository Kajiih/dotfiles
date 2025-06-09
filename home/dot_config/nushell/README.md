# Nushell Config Directory

## Structure

- [modules](./modules/) - Modules to `use` (during initialization or not):

  ```nu
  use bws_secrets.nu
  bws_secrets load-all
  ```

  - [modules/init](./modules/init/) - Modules designed to be `source`d in `config.nu`:

    ```nu
    # config.nu
    source init/custom_ls.nu
    ```

- [scripts](./scripts/) - Scripts to `run`

  ```nu
  nu "scripts/cargo_upgrade_all.nu"
  # or
  chmod +x scripts/cargo_upgrade_all.nu  # set permissions
  scripts/cargo_upgrade_all.nu
  # You can set the whole directory to executable with chmod +x -R scripts
  ```

- [data](./data/) - Data used by other tools in config
- [submodules](./submodules/) - Git submodules used in config
  - Check [this](https://www.chezmoi.io/user-guide/include-files-from-elsewhere/#include-a-subdirectory-from-a-url) to use with `Chezmoi`
- [completions](./completions/) - Command completions
- [.old](./.old/) - Temporary store for old data
