#!/usr/bin/env bash
# purpose: ensure ~/notes exists so Obsidian opens the shared vault cleanly
# distro: any
# runs as: user (dcli post_install_hook, run_hooks_as_user: true)
# idempotent: yes (mkdir -p only)
# calling hook: obsidian post_install, behavior always
set -euo pipefail

mkdir -p "${HOME}/notes"
echo "ensure-notes-dir: ~/notes exists."
