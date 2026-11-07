#!/usr/bin/env bash
# purpose: install the shared VSCodium extension set
# runs as: user (editors post_install_hook, run_hooks_as_user: true)
# idempotent: yes (codium skips extensions that are already installed)
# calling hook: editors post_install, behavior ask
set -euo pipefail

if ! command -v codium >/dev/null 2>&1; then
  echo "install-extensions: codium is not installed, skipping." >&2
  exit 0
fi

codium --install-extension ms-python.python
codium --install-extension hashicorp.terraform
codium --install-extension ms-azuretools.vscode-docker
