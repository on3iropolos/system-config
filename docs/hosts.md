# Hosts

Reference for both host files. Must stay in sync with `hosts/*.yaml`.

## Hosts

| Host | File | Distro | Manager | Processing | Modules |
|---|---|---|---|---|---|
| machine-serial | `hosts/machine-serial.yaml` | Ubuntu | apt | parallel | base, browser, security, dev, desktop-gnome |
| stump | `hosts/stump.yaml` | CachyOS | pacman + paru | sequential | base, browser, security, dev, noctalia |

## machine-serial

Work laptop on Ubuntu with stock GNOME.

```yaml
host: machine-serial
description: Work laptop on Ubuntu with stock GNOME
import:
  - hosts/shared/common.yaml
enabled_modules:
  - base
  - browser
  - security
  - dev
  - desktop-gnome
packages: []
exclude:
  - noctalia
  - github-cli
  - brave-bin
  - opencode
```

Processing stays on the dcli default (`parallel`).
Sets `package_manager: apt`, `flatpak_scope: user`, `auto_prune: false`, and
`default_apps` browser `brave-browser.desktop`.
Backups use `config_backups.max_backups: 5` and `system_backups.tool: timeshift`.
`editor: nano` falls back to `$EDITOR` when set.

## stump

Home laptop on CachyOS with Noctalia, Umbriel, and Greeter.

```yaml
host: stump
description: Home laptop on CachyOS with Noctalia shell and Umbriel compositor
import:
  - hosts/shared/common.yaml
enabled_modules:
  - base
  - browser
  - security
  - dev
  - noctalia
packages: []
exclude:
  - desktop-gnome
  - gh
  - brave-browser
```

Sets `aur_helper: paru`, `module_processing: sequential`, `flatpak_scope: user`,
and `auto_prune: false`. The Noctalia module supplies Alacritty and configures
and enables the `greetd` Noctalia Greeter session.
Install `paru` first per [docs/installation.md](installation.md), since CachyOS no longer preinstalls it.
