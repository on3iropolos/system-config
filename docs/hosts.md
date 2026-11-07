# Hosts

Reference for all three host files. Must stay in sync with `hosts/*.yaml`.

`stump` and `whimsyforge` are the deployed hosts. `machine-serial` is dormant; see
[Deferral](#deferral) below.

## Hosts

| Host | File | Distro | Manager | Processing | Modules |
|---|---|---|---|---|---|
| machine-serial | `hosts/machine-serial.yaml` | Ubuntu | apt | parallel | base, browser, security, dev, desktop-gnome |
| stump | `hosts/stump.yaml` | CachyOS | pacman + paru | sequential | base, cachyos, git, ssh, fish, cli-tools, editors, browser, security, dev, media, noctalia |
| whimsyforge | `hosts/whimsyforge.yaml` | CachyOS | pacman + paru | sequential | base, cachyos, git, ssh, fish, cli-tools, editors, browser, security, dev, media, desktop-gnome, gaming |

## machine-serial

Work laptop on Ubuntu with stock GNOME. Dormant.

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
  - cachyos
  - git
  - ssh
  - fish
  - cli-tools
  - editors
  - browser
  - security
  - dev
  - media
  - noctalia
packages: []
exclude:
  - desktop-gnome
```

Sets `aur_helper: paru`, `module_processing: sequential`, `flatpak_scope: user`,
and `auto_prune: false`. The Noctalia module supplies Kitty and configures
and enables the `greetd` Noctalia Greeter session. Its managed Umbriel
configuration sets the internal `eDP-1` 3000x2000 panel to 1.5 scale.
Install `paru` first per [docs/installation.md](installation.md), because CachyOS no longer preinstalls it.

`exclude:` currently carries only `desktop-gnome`, a module name. There are no
package-level exclusions because the shared modules declare only names that
resolve on CachyOS. The key is retained: it still applies on the dcli
declaration path, and it is needed again once machine-serial returns.

## whimsyforge

Home desktop on CachyOS with stock GNOME.

```yaml
host: whimsyforge
description: Home desktop on CachyOS with stock GNOME
import:
  - hosts/shared/common.yaml
enabled_modules:
  - base
  - cachyos
  - git
  - ssh
  - fish
  - cli-tools
  - editors
  - browser
  - security
  - dev
  - media
  - desktop-gnome
  - gaming
packages: []
exclude:
  - noctalia
```

Sets `aur_helper: paru`, `module_processing: sequential`, `flatpak_scope: user`,
and `auto_prune: false`. The `desktop-gnome` module supplies `gnome-shell` and
`gdm`, and the host service policy enables `gdm`. The `gaming` module supplies
Steam plus gamemode, mangohud, gamescope, and goverlay. NVIDIA drivers and the
32-bit driver stay adopted, not declared; multilib must be enabled for the
`lib32-*` entries.

`exclude:` carries only `noctalia`, mirroring `stump`. There are no
package-level exclusions because the shared modules declare only names that
resolve on CachyOS.

## Adopted baseline

`stump` and `whimsyforge` did not start from the minimal profile in
[docs/installation.md](installation.md). They are existing CachyOS systems that
dcli was retrofitted onto. `stump` carries roughly 171 packages the config does
not declare, plus 7 flatpak runtime layers that flatpak manages itself.
`whimsyforge` carries its own uncounted baseline; count it before relying on
the number.

Those are deliberately left unmanaged. They are the OS installer's artifacts,
hardware drivers for each machine's GPU and firmware, kernels and boot tooling,
desktop fonts, and storage utilities implied by the chosen layout. Declaring
them would tie the configuration to one distro release and to exact
hardware, and none of it is portable to `machine-serial`.

A small, deliberate subset *is* declared, because the configuration depends on
it or because it is a genuine choice rather than installer residue:

- `paru` and `cachyos-fish-config`, in the `cachyos` module. The first backs
  `aur_helper`, the second is the file `config.fish` sources.
- `timeshift`, in `base`, because all hosts set it as the backup tool.
- `cli-tools` and `editors`, curated from the packages the user actually chose.

Everything else stays adopted and undeclared. This is a decision, not an
oversight.

## Never prune CachyOS hosts

`dcli sync --prune` removes packages that are not declared, which on these hosts
means the entire adopted baseline: `linux-cachyos`, every `cachyos-*` package,
the NVIDIA drivers, and the desktop session.

It is also impossible to review safely here. Both hosts run sequential module
processing, and `dcli sync --dry-run` reports that dry run is not supported in
sequential mode, so there is no way to preview the removals before applying
them. The documented precondition for prune cannot be satisfied on either host.

`auto_prune` is `false`, so this only matters when `--prune` is passed
explicitly. Treat that flag as forbidden on `stump` and `whimsyforge` until a future pass adopts
the baseline into a managed module or sequential dry-run support lands.

## Deferral

`machine-serial` is dormant so that the CachyOS hosts can be stabilised first. Four
module changes assume a CachyOS-only world and must be reverted when that host
comes back:

- `modules/git/packages.yaml` declares `github-cli` only. Re-add `gh` for the
  apt name, then exclude it on `stump` and `whimsyforge`.
- `modules/browser/packages.yaml` declares `brave-bin` only. Re-add
  `brave-browser` for the apt name, then exclude it on `stump` and `whimsyforge`.
- `modules/ssh/packages.yaml` declares `openssh`. On Ubuntu that name is a
  metapackage that also pulls in `openssh-server`. Re-add `openssh-client` as
  a separate entry and exclude `openssh` on `machine-serial`.
- `modules/desktop-gnome/packages.yaml` declares `gnome-shell` and `gdm` only.
  Re-add `ubuntu-desktop-minimal` for the apt name, then exclude it on `stump`
  and `whimsyforge`.

The per-host `exclude:` mechanism is unreliable in `dcli sync` until the
upstream defect recorded in `.local/dcli-bugs.md` is fixed, so restoring both
apt names depends on that landing or on splitting them into per-host modules.