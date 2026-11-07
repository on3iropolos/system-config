#!/usr/bin/env bash
# purpose: enforce a default-deny firewall policy with no exceptions
# runs as: root (firewall post_install_hook, run_hooks_as_user: false)
# idempotent: yes (every ufw invocation is a no-op when already applied)
# calling hook: firewall post_install, behavior always
set -euo pipefail

# No allow rules: the rebuilt hosts run no inbound services and no libvirt.
# If an inbound service is ever added, declare its rule here.
ufw default deny incoming
ufw default allow outgoing
ufw --force enable
