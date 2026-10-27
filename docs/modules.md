# Modules

Reference for all thirteen modules. Must stay in sync with `modules/*/module.yaml` and `modules/*/packages.yaml`.

## Modules

| Module | Description | Packages | Hooks | Dotfiles | Enabled on |
|---|---|---|---|---|---|
| base | Shared core tools | fzf, xdg-utils, flatpak, timeshift | `install-timeshift.sh` | none | machine-serial, stump |
| cachyos | CachyOS repo tooling and shell defaults | paru, cachyos-fish-config | none | none | stump |
| git | Git identity and GitHub CLI | git, github-cli | none | `~/.gitconfig` | machine-serial, stump |
| ssh | OpenSSH client and GitHub identity | openssh | none | `~/.ssh/config` | machine-serial, stump |
| fish | fish shell and ssh-agent bootstrap | fish | none | `~/.config/fish/conf.d/ssh-agent.fish` | machine-serial, stump |
| cli-tools | Command-line utilities | alacritty, btop, duf, fastfetch, glances, ripgrep, wget, rsync, plocate | none | none | machine-serial, stump |
| editors | Text and GUI editors | nano, nano-syntax-highlighting, vim, vscodium | none | none | machine-serial, stump |
| browser | Brave browser | brave-bin | `install-brave-apt.sh` | none | machine-serial, stump |
| security | Bitwarden password manager | bitwarden | none | none | machine-serial, stump |
| dev | opencode AI agent | opencode | `install-opencode.sh` | none | machine-serial, stump |
| desktop-gnome | Stock GNOME desktop | ubuntu-desktop-minimal | none | none | machine-serial |
| noctalia | Noctalia + Umbriel + Greeter | alacritty, greetd, noctalia, umbriel, noctalia-greeter, python | `configure-greetd.sh` | sync `dotfiles/` | stump |
| cachyos-repo | CachyOS repo | cachyos-keyring, cachyos-mirrorlist | `add-cachyos-repo.sh` | none | not enabled |

## Package name notes

- The `git` module declares `github-cli`, which owns `/usr/bin/gh` on CachyOS.
  The apt name `gh` is deferred with `machine-serial`.
- `git` and `github-cli` live in the `git` module rather than `base`, which
  keeps each tool with the dotfile that configures it.
- `openssh` is the CachyOS name and is correct here. On Ubuntu the same name is
  a metapackage that also pulls in `openssh-server`; that split is deferred
  with `machine-serial`.
- `fish` installs on both hosts, but installing the package does not change the
  login shell. Selecting it stays a manual `chsh` step.
- `timeshift` is declared in `base` because both hosts set it as the
  `system_backups` tool. `backup_on_sync` fires before module processing, so on
  a blank system it must already be installed; see [Installation](installation.md).
  Its `pre_install_hook` writes `/etc/timeshift/timeshift.json` so snapshots land
  on the disk instead of a tmpfs staging path; see [system backups](services.md#system-backups).
- `paru` and `cachyos-fish-config` are CachyOS-only names and live in the
  `cachyos` module, scoped to `stump` so they never reach `machine-serial`.
- `cachyos-fish-config` is the file `~/.config/fish/config.fish` sources.
- `cli-tools` and `editors` were curated by hand from the packages the CachyOS
  installer had already placed on the machine. The rest of that set stays
  unmanaged; see the adopted-baseline notes in [Hosts](hosts.md).
- `vscodium` is declared by package name and provides both the `codium` and
  `vscodium` binaries.
- `alacritty` is declared in `cli-tools` and `noctalia`, and is `stump`'s configured
  terminal in `default_apps`.
- `brave-bin` installs on CachyOS from the `cachyos` repository. It is not an
  AUR package, so nothing in this repository depends on `paru` to resolve it.
  The apt name `brave-browser` is deferred with `machine-serial`.
- `opencode` installs from Arch extra on CachyOS and is excluded on `machine-serial`.
- Bitwarden uses the Arch extra `bitwarden` package (desktop) plus `gnome-keyring`
  as Secret Service provider. Ubuntu has no apt equivalent, so `machine-serial`
  needs a manual install.
- `ubuntu-desktop-minimal` is a no-op on stock Ubuntu and is scoped to `machine-serial`.
- `noctalia` ships in Arch extra, `noctalia-greeter` and `umbriel` in the CachyOS repos.
- Umbriel autostarts Noctalia and owns the Noctalia IPC keybindings through the
  Noctalia module's managed Umbriel dotfile.
- `paru` stays declared on `stump` because `aur_helper` names it and the user
  installs AUR packages by hand, not because any declared package needs it.
- `cachyos-repo` targets plain Arch hosts and stays disabled here.

## Hook notes

Hooks live in the owning module's `scripts/` directory, and behavior plus user
are set in each `module.yaml`.

- `install-brave-apt.sh` runs as the browser pre-install hook, once, as root.
- `install-timeshift.sh` runs as the base pre-install hook, once, as root.
- `install-opencode.sh` runs as the dev post-install hook, on ask, as the user.
- `add-cachyos-repo.sh` runs as the cachyos-repo pre-install hook, once, as root.
- `configure-greetd.sh` runs as the noctalia post-install hook, always, as root.

## Dotfile notes

The `git`, `ssh`, and `fish` modules ship identical dotfiles to both hosts with
no per-host overrides, so the shared account, GitHub identity, and login shell
stay the same on each machine. Details, including the manual key material
policy, are in [Dotfiles](dotfiles.md).

## Conflicts

- `desktop-gnome` conflicts with `noctalia`.
- `noctalia` conflicts with `desktop-gnome`.
- `machine-serial` is dormant. Its `exclude:` list still names `github-cli`,
  `brave-bin`, and `opencode`, which the modules no longer declare against it.
  See the deferral notes in [Hosts](hosts.md#deferral).
- `stump` excludes only `desktop-gnome`. There are no package-level exclusions
  while the modules declare CachyOS-resolvable names only.
