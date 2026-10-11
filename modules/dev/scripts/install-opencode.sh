#!/usr/bin/env bash
# purpose: install opencode when no native package exists (e.g. Ubuntu apt)
# distro: any (runs the upstream installer only when opencode is missing)
# runs as: user (dcli post_install_hook, run_hooks_as_user: true)
# idempotent: yes (skips when opencode is already on PATH)
# calling hook: dev post_install, behavior ask
set -euo pipefail

if command -v opencode >/dev/null 2>&1; then
  echo "install-opencode: opencode already installed, skipping."
  exit 0
fi

if command -v pacman >/dev/null 2>&1; then
  echo "install-opencode: on Arch-based systems prefer 'sudo pacman -S opencode', skipping script install."
  exit 0
fi

curl -fsSL https://opencode.ai/install | bash
echo "install-opencode: opencode installed via upstream script."
