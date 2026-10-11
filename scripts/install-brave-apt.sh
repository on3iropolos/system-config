#!/usr/bin/env bash
# purpose: add the Brave browser apt repository on Debian/Ubuntu
# distro: Ubuntu / Debian (apt only, no-op elsewhere)
# runs as: root (dcli pre_install_hook, run_hooks_as_user: false)
# idempotent: yes (skips when brave sources list already exists)
# calling hook: browser pre_install, behavior once
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "install-brave-apt: apt not found (Arch uses AUR brave-bin), skipping."
  exit 0
fi

if [ -f /etc/apt/sources.list.d/brave-browser-release.list ]; then
  echo "install-brave-apt: Brave repo already present, skipping."
  exit 0
fi

apt-get install -y curl gnupg
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" >/etc/apt/sources.list.d/brave-browser-release.list
apt-get update
echo "install-brave-apt: Brave apt repo added."
