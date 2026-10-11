# Modules

Reference for all seven modules. Must stay in sync with `modules/*/module.yaml` and `modules/*/packages.yaml`.

## Modules

| Module | Description | Packages | Hooks | Dotfiles | Enabled on |
|---|---|---|---|---|---|
| base | Shared core tools | git, gh, github-cli, fzf, xdg-utils, flatpak | none | none | machine-serial, stump |
| browser | Brave browser | brave-bin, brave-browser | `install-brave-apt.sh` | none | machine-serial, stump |
| security | Bitwarden password manager | flatpak:com.bitwarden.desktop | none | none | machine-serial, stump |
| dev | opencode AI agent | opencode | `install-opencode.sh` | none | machine-serial, stump |
| desktop-gnome | Stock GNOME desktop | ubuntu-desktop-minimal | none | none | machine-serial |
| noctalia | Noctalia + Umbriel + Greeter | noctalia, umbriel, noctalia-greeter | none | sync `dotfiles/` | stump |
| cachyos-repo | CachyOS repo | cachyos-keyring, cachyos-mirrorlist | `add-cachyos-repo.sh` | none | not enabled |

## Package name notes

- `gh` installs on Ubuntu and is excluded on `stump`, where `github-cli` provides it.
- `github-cli` installs on CachyOS and is excluded on `machine-serial`.
- `brave-browser` installs on Ubuntu via the Brave repo hook and is excluded on `stump`.
- `brave-bin` installs on CachyOS via `paru` and is excluded on `machine-serial`.
- `opencode` installs from Arch extra on CachyOS and is excluded on `machine-serial`.
- Bitwarden uses `flatpak:com.bitwarden.desktop` to dodge the apt and pacman divergence.
- `ubuntu-desktop-minimal` is a no-op on stock Ubuntu and is scoped to `machine-serial`.
- `noctalia` ships in Arch extra, `noctalia-greeter` and `umbriel` in the CachyOS repos.
- `paru` stays required on `stump` for the AUR-only `brave-bin`.
- `cachyos-repo` targets plain Arch hosts and stays disabled here.

## Hook notes

Hooks live in the owning module's `scripts/` directory, and behavior plus user
are set in each `module.yaml`.

- `install-brave-apt.sh` runs as the browser pre-install hook, once, as root.
- `install-opencode.sh` runs as the dev post-install hook, on ask, as the user.
- `add-cachyos-repo.sh` runs as the cachyos-repo pre-install hook, once, as root.

## Conflicts

- `desktop-gnome` conflicts with `noctalia`.
- `noctalia` conflicts with `desktop-gnome`.
- `machine-serial` excludes `noctalia`, `github-cli`, `brave-bin`, and `opencode`.
- `stump` excludes `desktop-gnome`, `gh`, and `brave-browser`.
