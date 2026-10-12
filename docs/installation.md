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
CachyOS no longer preinstalls `paru`, which stays declared on `stump` because
`aur_helper` names it.

```bash
sudo pacman -Syu
sudo pacman -S --needed git base-devel paru flatpak timeshift
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
```

`timeshift` must be present before the first sync, because `system_backups`
takes a snapshot before module processing runs. `cachyos-fish-config` ships with
the CachyOS desktop profile and supplies the file `config.fish` sources. Both
are declared in the repository, but a blank system needs them present before dcli
can manage anything.

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
Clone the public repository over HTTPS, because the first checkout has no SSH
key yet. The `ssh` module installs `~/.ssh/config` during the first sync, and
the remote switches to SSH afterwards. Match the machine hostname, then verify.

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

## SSH identity

The `ssh` module manages the client configuration only. Every machine creates
its own key pair, so the hosts stay independently revocable and a compromised
laptop does not expose the other. Register both public keys on the same GitHub
account.

Run on `machine-serial` and on `stump`:

```bash
ssh-keygen -t ed25519 -C on3iropolos@gmail.com -f ~/.ssh/on3iropolos-ssh
chmod 600 ~/.ssh/on3iropolos-ssh
ssh-add ~/.ssh/on3iropolos-ssh
chsh -s "$(command -v fish)"
```

The `chmod` is not optional: OpenSSH refuses to load a private key that other
users can read. Add `~/.ssh/on3iropolos-ssh.pub` under
[GitHub SSH keys](https://github.com/settings/keys), then confirm and switch the
remote from HTTPS to SSH.

```bash
ssh -T git@github.com
git remote set-url origin git@github.com:on3iropolos/system-config.git
git ls-remote origin
```

`ssh -T` must print `Hi on3iropolos!`. See [Dotfiles](dotfiles.md) for how the
managed symlinks behave.

## Next steps

- Read [docs/configuration.md](configuration.md) for the layout.
- Read [docs/operations.md](operations.md) for daily commands.
- After the initial `stump` sync, reboot to start the configured Noctalia Greeter.
  Keep a TTY available for recovery; see [docs/services.md](services.md) and
  the [Noctalia greeter installation](https://docs.noctalia.dev/greeter/installation/).
