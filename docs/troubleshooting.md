# Troubleshooting

How-to for common failures in this repository.

## AUR helper missing on CachyOS

CachyOS no longer preinstalls `paru`, but `stump` pins it and needs AUR packages.

```bash
sudo pacman -S --needed git base-devel paru
command -v paru
```

## Flatpak app fails

The `security` module needs Flatpak plus the Flathub user remote.

```bash
sudo pacman -S --needed flatpak
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
```

On Ubuntu instead:

```bash
sudo apt install -y flatpak
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Sync preview surprises

```bash
dcli sync --dry-run
dcli find <package>
dcli status
```

`gh` installs on Ubuntu and is excluded on CachyOS, where `github-cli` provides it.
`brave-browser` installs on Ubuntu via `scripts/install-brave-apt.sh`.
`brave-bin` installs on CachyOS via `paru` and is excluded on Ubuntu.

## opencode missing

Ubuntu has no native package, so `opencode` is excluded on `machine-serial`.
The `dev` post-install hook installs it per user.

```bash
command -v opencode
bash scripts/install-opencode.sh
```

On CachyOS prefer the native package.

```bash
sudo pacman -S opencode
```

## CachyOS repo hook is a no-op

Genuine CachyOS systems already configure the CachyOS repos.
`scripts/add-cachyos-repo.sh` detects `[cachyos]` and skips.
The `cachyos-repo` module targets plain Arch hosts and is not enabled here.

## Noctalia config rejected

Validate local Noctalia v5 TOML before syncing dotfiles.

```bash
noctalia config validate ~/.config/noctalia/config.toml
```

GUI overrides live in `~/.local/state/noctalia/settings.toml` and always win.
See [docs/dotfiles.md](dotfiles.md) for the sync layout.

## TUI or backups fail

```bash
sudo pacman -S fzf timeshift
sudo apt install -y fzf timeshift
```
