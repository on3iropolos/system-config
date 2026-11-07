# Modules

Reference for all eighteen modules. Must stay in sync with `modules/*/module.yaml` and `modules/*/packages.yaml`.

## Modules

| Module | Description | Packages | Hooks | Dotfiles | Enabled on |
|---|---|---|---|---|---|
| base | Shared core tools | fzf, xdg-utils, flatpak, timeshift | `install-timeshift.sh` | none | machine-serial, stump, whimsyforge |
| cachyos | CachyOS repo tooling and shell defaults | paru, cachyos-fish-config | none | none | stump, whimsyforge |
| git | Git identity and GitHub CLI | git, github-cli | none | `~/.gitconfig` | machine-serial, stump, whimsyforge |
| ssh | OpenSSH client and GitHub identity | openssh | none | `~/.ssh/config` | machine-serial, stump, whimsyforge |
| fish | fish shell and ssh-agent bootstrap | fish | none | `~/.config/fish/conf.d/ssh-agent.fish` | machine-serial, stump, whimsyforge |
| cli-tools | Command-line utilities | alacritty, btop, duf, fastfetch, glances, ripgrep, wget, rsync, plocate | none | none | machine-serial, stump, whimsyforge |
| editors | Text and GUI editors | nano, nano-syntax-highlighting, vim, vscodium | `install-extensions.sh` | none | machine-serial, stump, whimsyforge |
| browser | Brave browser | brave-bin | `install-brave-apt.sh` | none | machine-serial, stump, whimsyforge |
| security | Bitwarden password manager | bitwarden | none | none | machine-serial, stump, whimsyforge |
| dev | opencode AI agent | opencode | `install-opencode.sh` | none | machine-serial, stump, whimsyforge |
| media | Stremio and Spotify streaming apps | flatpak:com.stremio.Stremio, flatpak:com.spotify.Client | none | none | stump, whimsyforge |
| desktop-gnome | GNOME desktop | gnome-shell, gdm, gnome-session, gnome-control-center, nautilus | none | none | whimsyforge (machine-serial deferred) |
| gaming | Steam gaming tools | steam, gamemode, lib32-gamemode, mangohud, lib32-mangohud, gamescope, goverlay | none | none | whimsyforge |
| firewall | UFW default-deny firewall | ufw | `apply-ufw.sh` | none | stump, whimsyforge |
| docker | Docker engine with shared daemon config | docker | `configure-daemon.sh` | none | stump, whimsyforge |
| obsidian | Obsidian notes with shared vault pointer | obsidian | none | `~/.config/obsidian/obsidian.json` | stump, whimsyforge |
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
- `fish` installs on all hosts, but installing the package does not change the
  login shell. Selecting it stays a manual `chsh` step.
- `timeshift` is declared in `base` because all hosts set it as the
  `system_backups` tool. `backup_on_sync` fires before module processing, so on
  a blank system it must already be installed; see [Installation](installation.md).
  Its `pre_install_hook` writes `/etc/timeshift/timeshift.json` so snapshots land
  on the disk instead of a tmpfs staging path; see [system backups](services.md#system-backups).
- `paru` and `cachyos-fish-config` are CachyOS-only names and live in the
  `cachyos` module, scoped to `stump` and `whimsyforge` so they never reach `machine-serial`.
- `cachyos-fish-config` is the file `~/.config/fish/config.fish` sources.
- `cli-tools` and `editors` were curated by hand from the packages the CachyOS
  installer had already placed on the machine. The rest of that set stays
  unmanaged; see the adopted-baseline notes in [Hosts](hosts.md).
- `vscodium` is declared by package name and provides both the `codium` and
  `vscodium` binaries.
- `alacritty` is declared in `cli-tools` and `noctalia`, and is the configured
  terminal in `default_apps` on `stump` and `whimsyforge`.
- `brave-bin` installs on CachyOS from the `cachyos` repository. It is not an
  AUR package, so nothing in this repository depends on `paru` to resolve it.
  The apt name `brave-browser` is deferred with `machine-serial`.
- `opencode` installs from Arch extra on CachyOS and is excluded on `machine-serial`.
- Bitwarden uses the Arch extra `bitwarden` package (desktop) plus `gnome-keyring`
  as Secret Service provider. Ubuntu has no apt equivalent, so `machine-serial`
  needs a manual install.
- `media` declares `flatpak:com.stremio.Stremio` for Stremio, the Flathub flatpak ref, so no distro package name is needed. It is enabled on `stump` and `whimsyforge`.
- `media` declares `flatpak:com.spotify.Client` for Spotify, the Flathub flatpak ref, so no distro package name is needed; it rides along with the Stremio entry.
- `gnome-shell`, `gdm`, `gnome-session`, `gnome-control-center`, and `nautilus`
  are the CachyOS names in `desktop-gnome`, scoped to `whimsyforge`. The set
  covers a minimal-base install (session, login, settings, files); iterate
  post-rebuild if anything is missing. The apt name `ubuntu-desktop-minimal`
  is deferred with `machine-serial`.
- `gaming` declares Steam plus gamemode, mangohud, gamescope, and goverlay on
  `whimsyforge` only. Multilib must be enabled for the `lib32-*` entries, and
  the NVIDIA drivers stay adopted rather than declared.
- `ufw` is declared in `firewall` as pure default-deny with no exceptions: the
  rebuilt hosts run no inbound services and no libvirt. Declare any future
  allow rule in `apply-ufw.sh`.
- `docker` is declared with the shared `/etc/docker/daemon.json`
  (172.31.0.0/16 pool, live-restore, no userland-proxy). Daemon changes need a
  manual `systemctl restart docker`; group membership stays manual and adopted.
- `obsidian` declares the package plus the managed vault pointer at
  `~/.config/obsidian/obsidian.json`. The `~/notes` directory itself stays
  manual; create it on hosts that lack it.
- The `editors` hook installs the shared VSCodium set (`ms-python.python`,
  `hashicorp.terraform`, `ms-azuretools.vscode-docker`). It only adds;
  unwanted extensions stay a manual `codium --uninstall-extension`.
- `noctalia` ships in Arch extra, `noctalia-greeter` and `umbriel` in the CachyOS repos.
- Umbriel autostarts Noctalia and owns the Noctalia IPC keybindings through the
  Noctalia module's managed Umbriel dotfile.
- `paru` stays declared on the CachyOS hosts because `aur_helper` names it and the user
  installs AUR packages by hand, not because any declared package needs it.
- `cachyos-repo` targets plain Arch hosts and stays disabled here.

## Hook notes

Hooks live in the owning module's `scripts/` directory, and behavior plus user
are set in each `module.yaml`.

- `install-brave-apt.sh` runs as the browser pre-install hook, once, as root.
- `install-timeshift.sh` runs as the base pre-install hook, once, as root.
- `apply-ufw.sh` runs as the firewall post-install hook, always, as root.
- `configure-daemon.sh` runs as the docker post-install hook, always, as root.
- `install-opencode.sh` runs as the dev post-install hook, on ask, as the user.
- `add-cachyos-repo.sh` runs as the cachyos-repo pre-install hook, once, as root.
- `install-extensions.sh` runs as the editors post-install hook, on ask, as the user.
- `configure-greetd.sh` runs as the noctalia post-install hook, always, as root.

## Dotfile notes

The `git`, `ssh`, and `fish` modules ship identical dotfiles to all hosts with
no per-host overrides, so the shared account, GitHub identity, and login shell
stay the same on each machine. Details, including the manual key material
policy, are in [Dotfiles](dotfiles.md).

## Conflicts

- `desktop-gnome` conflicts with `noctalia`.
- `noctalia` conflicts with `desktop-gnome`.
- `machine-serial` is dormant. Its `exclude:` list still names `github-cli`,
  `brave-bin`, and `opencode`, which the modules no longer declare against it.
  See the deferral notes in [Hosts](hosts.md#deferral).
- `stump` excludes only `desktop-gnome`, and `whimsyforge` excludes only
  `noctalia`. There are no package-level exclusions
  while the modules declare CachyOS-resolvable names only.
