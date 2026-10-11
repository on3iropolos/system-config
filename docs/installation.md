# Installation

Tutorial for installing dcli and pulling this repository.
Follow the [dcli installation guide](https://gitlab.com/theblackdon/dcli#installation) as normative.

## CachyOS (stump)

### Installer preferences

Post-OS guide only; follow the [CachyOS preparation steps](https://wiki.cachyos.org/installation/installation_prepare/) and [CachyOS installation](https://wiki.cachyos.org/installation/installation_on_root/) as normative for the OS itself.
Our preferences for `stump`:

- Erase disk (single-disk, nothing to migrate), `btrfs` with default subvolumes, encryption on.
- Bootloader `Limine`, UEFI with Secure Boot disabled, stable internet (online installer).
- Minimal base (`No Desktop` selection); dcli provides Noctalia plus Umbriel plus Greeter.
- Kernel `linux-cachyos` default, drivers via automatic detection (proprietary NVIDIA only if applicable).
- User `on3i`, hostname `stump` set in the installer (`hostnamectl` below is a fallback).

Install build tools, an AUR helper, and Flatpak first.
CachyOS no longer preinstalls `paru`, and this repo needs AUR packages (`brave-bin`).

```bash
sudo pacman -Syu
sudo pacman -S --needed git base-devel paru flatpak timeshift
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
```

Install dcli from the AUR. The upstream GitLab Pages binary repository currently
returns HTTP 403 for its package database, so do not add it to `pacman.conf`.
The `dcli-arch-git` package builds the latest dcli source locally and is the
upstream-supported fallback.

```bash
paru -S --needed dcli-arch-git
dcli --version
```

## Ubuntu (machine-serial)

Install Flatpak alongside the build tools, then use the manual install script.

```bash
sudo apt update
sudo apt install -y git curl build-essential flatpak
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
git clone https://gitlab.com/theblackdon/dcli.git
cd dcli
./install.sh
```

The script builds the release binary and installs to `/usr/local/bin/dcli`.

## Pull this repo

Canonical checkout is `~/src/system-config` on every machine.
`~/.config/arch-config` is a symlink for dcli, which hardcodes that path on all distros (Arch and Ubuntu alike).
Clone the public repository over HTTPS; SSH is configured after system bootstrap,
before the first push. Match the machine hostname, then verify.

```bash
mkdir -p ~/src
git clone https://github.com/on3iropolos/system-config.git ~/src/system-config
mkdir -p ~/.config
ln -s ~/src/system-config ~/.config/arch-config
ls -l ~/.config/arch-config
sudo hostnamectl set-hostname stump
hostname
```

Set `host: stump` in `~/src/system-config/config.yaml`, then bootstrap the
machine:

```bash
dcli status
dcli sync
dcli validate
dcli status
```

The first sync installs declared packages before configuring default
applications. Run validation afterward because the configured desktop-file IDs
do not exist until their provider packages have been installed.

Replace `stump` with `machine-serial` on the work laptop.
The Ubuntu work laptop follows the same `~/src` checkout plus symlink step; only `host: machine-serial` and the apt install method differ.

## Next steps

- Read [docs/configuration.md](configuration.md) for the layout.
- Read [docs/operations.md](operations.md) for daily commands.
- After the initial `stump` sync, reboot to start the configured Noctalia Greeter.
  Keep a TTY available for recovery; see [docs/services.md](services.md) and
  the [Noctalia greeter installation](https://docs.noctalia.dev/greeter/installation/).
