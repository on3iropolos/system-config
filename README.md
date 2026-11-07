# system-config

Declarative [dcli](https://gitlab.com/theblackdon/dcli) setup for two Linux laptops and a Linux desktop.
`machine-serial` runs Ubuntu with stock GNOME for work.
`stump` runs CachyOS with the Noctalia shell family for home.
`whimsyforge` runs CachyOS with stock GNOME for home.
Shared core tools live in `modules/` so all hosts stay in sync.

`stump` and `whimsyforge` are the deployed hosts. `machine-serial` is dormant until stump is
stable; see the deferral notes in [docs/hosts.md](docs/hosts.md#deferral).

## Daily workflow after bootstrap

```bash
dcli validate
dcli sync --dry-run
dcli sync
dcli status
```

For a blank-system bootstrap, follow [docs/installation.md](docs/installation.md).
First-time checkout is `~/src/system-config`, with `~/.config/arch-config`
symlinked to it. Commit and push configuration changes separately through the
[Git workflow](docs/operations.md#git-workflow).

## Hosts

| Host | Distro | Pkg manager | Modules enabled | Purpose |
|---|---|---|---|---|
| `machine-serial` | Ubuntu | apt | base, git, ssh, fish, browser, security, dev, desktop-gnome | Work laptop, GNOME |
| `stump` | CachyOS | pacman + paru | base, git, ssh, fish, browser, security, dev, media, noctalia, firewall, docker, obsidian | Home laptop, Noctalia |
| `whimsyforge` | CachyOS | pacman + paru | base, git, ssh, fish, browser, security, dev, media, desktop-gnome, gaming, firewall, docker, obsidian | Home desktop, GNOME |

Details: [docs/hosts.md](docs/hosts.md) and `hosts/machine-serial.yaml`, `hosts/stump.yaml`, plus `hosts/whimsyforge.yaml`.

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
| desktop-gnome | GNOME desktop | gnome-shell, gdm | none | none | whimsyforge (machine-serial deferred) |
| gaming | Steam gaming tools | steam, gamemode, lib32-gamemode, mangohud, lib32-mangohud, gamescope, goverlay | none | none | whimsyforge |
| firewall | UFW firewall with SSH and libvirt rules | ufw | `apply-ufw.sh` | none | stump, whimsyforge |
| docker | Docker engine with shared daemon config | docker | `configure-daemon.sh` | none | stump, whimsyforge |
| obsidian | Obsidian notes with shared vault pointer | obsidian | none | `~/.config/obsidian/obsidian.json` | stump, whimsyforge |
| noctalia | Noctalia + Umbriel + Greeter | noctalia, umbriel, noctalia-greeter | none | sync `dotfiles/` | stump |
| cachyos-repo | CachyOS repo | cachyos-keyring, cachyos-mirrorlist | `add-cachyos-repo.sh` | none | not enabled |

Details: [docs/modules.md](docs/modules.md).

## Three-machine workflow

```bash
dcli merge --dry-run
dcli module enable <name>
dcli sync
dcli repo push
dcli repo pull
```

`machine-serial` stays on parallel processing with no AUR.
`stump` and `whimsyforge` run sequential processing for ordered module installation.
Hook behavior and users are detailed in [docs/modules.md](docs/modules.md).
`desktop-gnome` and `noctalia` conflict and each host excludes the other DE.

## Docs

- [docs/installation.md](docs/installation.md) — per-distro dcli install.
- [docs/configuration.md](docs/configuration.md) — layout and conventions.
- [docs/hosts.md](docs/hosts.md) — host reference.
- [docs/modules.md](docs/modules.md) — module reference.
- [docs/operations.md](docs/operations.md) — daily commands.
- [docs/dotfiles.md](docs/dotfiles.md) — Noctalia dotfiles sync.
- [docs/services.md](docs/services.md) — services and default apps.
- [docs/troubleshooting.md](docs/troubleshooting.md) — fixes.
- [CHANGELOG.md](CHANGELOG.md) — release notes.
