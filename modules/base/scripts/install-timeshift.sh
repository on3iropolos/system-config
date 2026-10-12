#!/usr/bin/env bash
# purpose: give timeshift a persistent btrfs snapshot store
# distro: CachyOS / Arch with a btrfs root (no-op elsewhere)
# runs as: root (dcli pre_install_hook, run_hooks_as_user: false)
# idempotent: yes (skips when /etc/timeshift/timeshift.json already exists)
# calling hook: base pre_install, behavior once
set -euo pipefail

# Without a config, timeshift runs in first-run mode: it stages snapshots under
# /run, which is tmpfs, then unmounts them on exit. It reports success and
# leaves nothing behind, so `dcli sync` backups would silently evaporate.
config_file="/etc/timeshift/timeshift.json"

if [[ -f "${config_file}" ]]; then
  echo "install-timeshift: ${config_file} already exists, skipping."
  exit 0
fi

if ! command -v timeshift >/dev/null 2>&1; then
  # This hook runs before the module's own packages are installed, so on a blank
  # system timeshift is only present if installation.md was followed. Fail loudly
  # rather than leaving dcli to report successful backups that persist nothing.
  echo "install-timeshift: timeshift is not installed, cannot configure it." >&2
  echo "install-timeshift: install it first, see docs/installation.md." >&2
  exit 1
fi

if [[ "$(findmnt -no FSTYPE /)" != "btrfs" ]]; then
  echo "install-timeshift: root is not btrfs, skipping."
  exit 0
fi

device="$(findmnt -no SOURCE /)"
device="${device%%[*}"
# Prefer findmnt's own UUID lookup; blkid needs the device to be readable and
# stays silent rather than failing when it is not.
uuid="$(findmnt -no UUID / 2>/dev/null || true)"
if [[ -z "${uuid}" ]]; then
  uuid="$(blkid -s UUID -o value "${device}" 2>/dev/null || true)"
fi

if [[ -z "${uuid}" ]]; then
  echo "install-timeshift: could not read UUID for ${device}, skipping." >&2
  exit 1
fi

# The template shipped in /etc/timeshift/default.json predates this release: it
# carries the removed `include_btrfs_home` key and omits the
# include_btrfs_home_for_backup / _for_restore pair the binary actually reads.
# Both spellings are written below so the config works either way.
#
# Scheduling is left off because dcli drives snapshots through
# system_backups.backup_on_sync and backup_on_update. Enabling timeshift's own
# cron or systemd timers on top would double up.
cat >"${config_file}" <<EOF
{
  "backup_device_uuid" : "${uuid}",
  "parent_device_uuid" : "",
  "do_first_run" : "false",
  "btrfs_mode" : "true",
  "include_btrfs_home" : "true",
  "include_btrfs_home_for_backup" : "true",
  "include_btrfs_home_for_restore" : "true",
  "stop_cron_emails" : "true",
  "schedule_monthly" : "false",
  "schedule_weekly" : "false",
  "schedule_daily" : "false",
  "schedule_hourly" : "false",
  "schedule_boot" : "false",
  "count_monthly" : "2",
  "count_weekly" : "3",
  "count_daily" : "5",
  "count_hourly" : "6",
  "count_boot" : "5",
  "date_format" : "%Y-%m-%d %H:%M:%S",
  "snapshot_size" : "0",
  "snapshot_count" : "0",
  "exclude" : [
  ],
  "exclude-apps" : [
  ]
}
EOF

echo "install-timeshift: configured btrfs snapshots on ${device} (${uuid})."
echo "install-timeshift: run 'sudo timeshift --create --scripted' to verify."