# Installation

Tutorial for installing dcli and pulling this repository.
Follow the [dcli installation guide](https://gitlab.com/theblackdon/dcli#installation) as normative.

## CachyOS (stump)

Install build tools, an AUR helper, and Flatpak first.
CachyOS no longer preinstalls `paru`, and this repo needs AUR packages.

```bash
sudo pacman -Syu
sudo pacman -S --needed git base-devel paru flatpak timeshift
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
```

Use the binary repo, no compiling needed.

```bash
sudo nano /etc/pacman.conf
```

```ini
[dcli]
SigLevel = Never
Server = https://theblackdon.gitlab.io/dcli/$arch
```

```bash
sudo pacman -Sy dcli
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

## SSH access

Generate a key and add it to GitHub before cloning.
The canonical remote is SSH: `git@github.com:on3iropolos/system-config.git`.

```bash
ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
```

Verify access with `ssh -T` against GitHub before continuing.

```bash
ssh -T git@github.com
```

## Pull this repo

Canonical checkout is `~/src/system-config`.
`~/.config/arch-config` is a symlink for dcli, which reads that path.
Match the machine hostname, then verify.

```bash
mkdir -p ~/src
git clone git@github.com:on3iropolos/system-config.git ~/src/system-config
mkdir -p ~/.config
ln -s ~/src/system-config ~/.config/arch-config
ls -l ~/.config/arch-config
sudo hostnamectl set-hostname stump
hostname
```

Set `host: stump` in `~/src/system-config/config.yaml`, then run:

```bash
dcli validate
dcli status
```

Replace `stump` with `machine-serial` on the work laptop.

## Next steps

- Read [docs/configuration.md](configuration.md) for the layout.
- Read [docs/operations.md](operations.md) for daily commands.
