#!/usr/bin/env bash
# purpose: add the CachyOS pacman repository on Arch-based systems
# distro: CachyOS / Arch (pacman only, no-op elsewhere)
# runs as: root (dcli pre_install_hook, run_hooks_as_user: false)
# idempotent: yes (skips when [cachyos] already in pacman.conf)
# calling hook: cachyos-repo pre_install, behavior once
set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "add-cachyos-repo: pacman not found, skipping."
  exit 0
fi

if grep -q '^\[cachyos\]' /etc/pacman.conf 2>/dev/null; then
  echo "add-cachyos-repo: [cachyos] already present, skipping."
  exit 0
fi

cp -a /etc/pacman.conf "/etc/pacman.conf.bak-$(date +%Y%m%d%H%M%S)"
printf '%s\n' '[cachyos]' 'Include = /etc/pacman.d/cachyos-mirrorlist' >>/etc/pacman.conf
pacman -Sy --noconfirm cachyos-keyring cachyos-mirrorlist
echo "add-cachyos-repo: CachyOS repository added."
