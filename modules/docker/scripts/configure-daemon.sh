#!/usr/bin/env bash
# purpose: write the shared Docker daemon configuration
# runs as: root (docker post_install_hook, run_hooks_as_user: false)
# idempotent: yes (rewrites identical content; restarts nothing)
# calling hook: docker post_install, behavior always
set -euo pipefail

config_file="/etc/docker/daemon.json"
mkdir -p /etc/docker
cat >"${config_file}" <<'EOF'
{
  "default-address-pools": [
    { "base": "172.31.0.0/16", "size": 24 }
  ],
  "live-restore": true,
  "userland-proxy": false
}
EOF
chmod 0644 "${config_file}"
echo "configure-daemon: wrote ${config_file}; restart docker to apply changes."
