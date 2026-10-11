# Changelog

All notable changes to this repository follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Initial declarative layout with `config.yaml` pointer and `hosts/machine-serial.yaml` plus `hosts/stump.yaml`.
- Shared defaults in `hosts/shared/common.yaml`.
- Seven minimal modules: `base`, `browser`, `security`, `dev`, `desktop-gnome`, `noctalia`, `cachyos-repo`.
- Hook scripts for the CachyOS repo, Brave on apt, and the opencode fallback installer.
- Documentation set under `docs/` covering installation, configuration, hosts, modules, and more.

### Changed

- `noctalia` now installs Kitty and manages `greetd` with the
  `noctalia-greeter-session` wrapper for graphical login on `stump`.
- Umbriel now autostarts Noctalia and supplies its standard IPC keybindings.
- `cachyos-repo` is now a plain-Arch example and no longer enabled on `stump`.
- Variant package names resolve per host via dual entries plus `exclude:`.
- Noctalia dotfiles ship valid v5 `config.toml` instead of the v4-style stub.
- Both hosts enable only `NetworkManager` until later passes add providers.

### Fixed

- Documented `paru`, `base-devel`, `git`, Flatpak, and Flathub prerequisites.
- Corrected `noctalia-greeter` to the CachyOS repo package with greetd wiring notes.
- Pinned `timeshift` as a CachyOS prerequisite so `system_backups` works on a bare base.
- Canonical checkout is now `~/src/system-config` with `~/.config/arch-config` as a symlink; remote is `git@github.com:on3iropolos/system-config.git` on `main`.
- Clarified plain `git` versus `dcli repo` workflow in `docs/operations.md`.
- Clarified dcli hardcodes `~/.config/arch-config` on Arch and Ubuntu alike; `~/src` plus symlink applies to both hosts.
- Ignored machine-local `.local/` notes and prompts; scoped the no-bare-URL rule to prose so fenced commands keep raw URLs.
- Corrected `umbriel-git` (AUR placeholder) to `umbriel` from the CachyOS repos per [CachyOS-PKGBUILDS#1925](https://github.com/CachyOS/CachyOS-PKGBUILDS/issues/1925); `paru` stays required for AUR-only `brave-bin`.
- Added CachyOS installer preferences for `stump` (erase disk, `btrfs`, encryption on, `Limine`, minimal base, `linux-cachyos`, hostname `stump`) with normative CachyOS wiki links; post-OS scope unchanged.
