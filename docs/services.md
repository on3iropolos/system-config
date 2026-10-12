# Services

Minimal service and default-app policy for both hosts.

## Services

Both hosts enable `NetworkManager`, which the distro installers provide.
`stump` also enables `greetd`, supplied by the Noctalia module. Add services
only with a package that provides them.

```yaml
services:
  enabled:
    - NetworkManager
    - greetd # stump only
  disabled: []
```

Capture live state before editing.

```bash
dcli merge --services
```

## Default apps

Both hosts set Brave as the user-scope browser.

```yaml
default_apps:
  scope: user
  browser: brave-browser.desktop
```

Default applications use the installed `.desktop` file ID, not a package or
product name. `brave-bin` on CachyOS provides `brave-browser.desktop`, as does
`brave-browser` on Ubuntu once that host is brought back.

Capture live defaults before editing.

```bash
dcli merge --defaults
```

## Noctalia greeter

The `noctalia` module configures `/etc/greetd/config.toml` through its
idempotent root hook. It sets `greetd` to launch
`noctalia-greeter-session` as the `greeter` user, then the host service policy
enables `greetd`. Reboot after the first successful sync to start the graphical
login screen.

Keep another TTY available while changing display-manager configuration. See
the [Noctalia greeter installation](https://docs.noctalia.dev/greeter/installation/)
for recovery and compatibility guidance.

## System backups

Both hosts take system snapshots with timeshift, driven by dcli rather than by
timeshift's own timers.

```yaml
system_backups:
  enabled: true
  backup_on_sync: true
  backup_on_update: true
  tool: timeshift
  max_backups: 5
```

The `base` module's `install-timeshift.sh` hook writes
`/etc/timeshift/timeshift.json` before the first sync, enabling btrfs mode and
including `/home` in snapshots.

That hook exists because timeshift is unsafe without it. With no config file,
timeshift runs in first-run mode, stages the snapshot under `/run`, and unmounts
it on exit:

```text
BTRFS Snapshot saved successfully (0s)
```

`/run` is tmpfs, so the snapshot is gone before the command returns. dcli would
report a successful backup on every sync while nothing persisted. A successful
first-run snapshot is not evidence that backups work.

Two further details are worth knowing:

- The `/etc/timeshift/default.json` shipped by the package predates the
  installed timeshift. It still carries the removed `include_btrfs_home` key and
  omits `include_btrfs_home_for_backup` and `include_btrfs_home_for_restore`,
  which are the keys the binary actually reads. The hook writes both spellings.
- This root is btrfs, so `/home` is a separate subvolume. Without
  `include_btrfs_home_for_backup`, snapshots cover the root subvolume only and
  `/home` is not restorable from them.

Verify that snapshots persist, rather than trusting the exit status:

```bash
sudo timeshift --create --scripted
sudo timeshift --list
```

Snapshots that survive a `sync` appear as dated entries. See
[btrfs quotas](#snapshot-retention) before relying on `max_backups`.

## Snapshot retention

`max_backups` is set to 5, but btrfs quotas are not enabled on this
filesystem, so timeshift reports `btrfs: Quotas are not enabled` and cannot
enforce the count. Snapshots accumulate until the disk fills and nothing prunes
them automatically.

```bash
sudo btrfs quota enable /
```

Prune manually in the meantime:

```bash
sudo timeshift --list
sudo timeshift --delete --snapshot '<name>'
```

## Not yet covered

- `bluetooth` with `bluez` and `bluez-utils`.
