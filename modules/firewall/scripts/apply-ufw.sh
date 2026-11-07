#!/usr/bin/env bash
# purpose: enforce the default-deny firewall policy with SSH and libvirt rules
# runs as: root (firewall post_install_hook, run_hooks_as_user: false)
# idempotent: yes (every ufw invocation is a no-op when already applied)
# calling hook: firewall post_install, behavior always
set -euo pipefail

ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
# Additional service rules go here (mirrors the role's firewall_allowed_services
# list, currently empty). Keep virbr0 rules last; they cover libvirt guests.
ufw allow in on virbr0 comment 'Allow libvirt guest traffic'
ufw route allow in on virbr0 comment 'Allow libvirt routed traffic'
ufw --force enable
