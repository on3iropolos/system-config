# Changelog

All notable changes to this repository follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Initial declarative layout with `config.yaml` pointer and `hosts/machine-serial.yaml` plus `hosts/stump.yaml`.
- Shared defaults in `hosts/shared/common.yaml`.
- Seven minimal modules: `base`, `browser`, `security`, `dev`, `desktop-gnome`, `noctalia`, `cachyos-repo`.
- Hook scripts for the CachyOS repo, Brave on apt, and the opencode fallback installer.
- Three modules for the shared command-line identity: `git`, `ssh`, and `fish`.
- Managed dotfiles for `~/.gitconfig`, `~/.ssh/config`, and the fish
  `conf.d/ssh-agent.fish` agent fragment, identical on both hosts.
- `openssh` and `fish` packages, with `openssh-client` noted for apt.
- SSH identity section in the installation guide covering per-machine keys.
- Documentation set under `docs/` covering installation, configuration, hosts, modules, and more.

### Changed

- `noctalia` now installs Kitty and manages `greetd` with the
  `noctalia-greeter-session` wrapper for graphical login on `stump`.
- Umbriel now autostarts Noctalia and supplies its standard IPC keybindings.
- Umbriel configures stump's internal 3000x2000 `eDP-1` panel at 1.5 scale.
- `cachyos-repo` is now a plain-Arch example and no longer enabled on `stump`.
- Variant package names resolved per host via dual entries plus `exclude:`. The
  dual-entry pattern is now dormant with `machine-serial`.
- Noctalia dotfiles ship valid v5 `config.toml` instead of the v4-style stub.
- Both hosts enable only `NetworkManager` until later passes add providers.
- `git`, `gh`, and `github-cli` moved out of `base` into the new `git` module so
  each tool sits with the dotfile that configures it.
- The ssh-agent bootstrap moved from a hand-edited `config.fish` into a managed
  `conf.d` fragment, and now starts the agent with fish-native `string match`
  capture instead of `eval`, which fish rejects during startup.
- Installation guidance now clones over HTTPS first and switches the remote to
  SSH after the first sync, instead of configuring SSH ad hoc.
- `state/` is now ignored via `state/*` with `state/.gitignore` re-included, so
  the tracked marker file dcli validate expects can actually be committed.
- `machine-serial` is deferred so `stump` can be stabilised first. The `git` and
  `browser` modules now declare only CachyOS-resolvable package names, which
  removes the per-sync `gh` install failure caused by the upstream defect
  recorded in `.local/dcli-bugs.md`.
- Re-adding `machine-serial` requires `gh`, `brave-browser`, and a separate
  `openssh-client` entry, plus restoring the package-level excludes on both
  hosts. See the deferral notes in `docs/hosts.md`.
- Declared the packages the configuration actually depends on but left
  unmanaged: `paru` and `cachyos-fish-config` in a new `cachyos` module,
  `timeshift` in `base`, and hand-curated `cli-tools` and `editors` modules.
- Recorded the adopted baseline policy for `stump` in `docs/hosts.md`, which
  keeps the roughly 171 packages the CachyOS installer placed on this machine
  deliberately undeclared instead of capturing them with `dcli merge`.
- Added a `base` pre-install hook that writes `/etc/timeshift/timeshift.json`,
  enabling btrfs-mode snapshots that include `/home`. Without it, timeshift runs
  in first-run mode, stages snapshots under the `/run` tmpfs, and discards them
  on exit while still reporting success, so `system_backups` would appear to
  work while persisting nothing.

### Fixed

- `docs/hosts.md` listed the module sets from before `git`, `ssh`, and `fish`
  were added, so the host reference had drifted from `hosts/*.yaml`.
- Corrected the claim that `brave-bin` is an AUR package. It ships in the
  `cachyos` repository, so nothing declared here depends on `paru` to resolve it.
- `docs/operations.md` no longer advises `dcli sync --prune` on `stump`. The
  documented precondition, reviewing removals first, cannot be met there because
  sequential processing has no dry-run preview, and the removals would include
  the kernel and GPU drivers.
- Documented that the `/etc/timeshift/default.json` shipped by the timeshift
  package is stale against the installed binary, which reads
  `include_btrfs_home_for_backup` and `include_btrfs_home_for_restore` instead of
  the removed `include_btrfs_home`.
- Documented `paru`, `base-devel`, `git`, Flatpak, and Flathub prerequisites.
- Corrected `noctalia-greeter` to the CachyOS repo package with greetd wiring notes.
- Pinned `timeshift` as a CachyOS prerequisite so `system_backups` works on a bare base.
- Canonical checkout is now `~/src/system-config` with `~/.config/arch-config` as a symlink; remote is `git@github.com:on3iropolos/system-config.git` on `main`.
- Clarified plain `git` versus `dcli repo` workflow in `docs/operations.md`.
- Clarified dcli hardcodes `~/.config/arch-config` on Arch and Ubuntu alike; `~/src` plus symlink applies to both hosts.
- Ignored machine-local `.local/` notes and prompts; scoped the no-bare-URL rule to prose so fenced commands keep raw URLs.
- Corrected `umbriel-git` (AUR placeholder) to `umbriel` from the CachyOS repos per [CachyOS-PKGBUILDS#1925](https://github.com/CachyOS/CachyOS-PKGBUILDS/issues/1925); `paru` stays required for AUR-only `brave-bin`.
- Added CachyOS installer preferences for `stump` (erase disk, `btrfs`, encryption on, `Limine`, minimal base, `linux-cachyos`, hostname `stump`) with normative CachyOS wiki links; post-OS scope unchanged.
