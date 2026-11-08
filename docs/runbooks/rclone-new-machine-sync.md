# Runbook: notes sync on a new machine

Bring up the `~/notes` bisync on a host that has never synced. Ends with the timer enabled and the first sync verified.

## Prerequisites

- `dcli sync` completed on the new host (installs `rclone`, links the user units, creates `~/notes`).
- The OAuth client ID and secret from the Bitwarden Login item `Google API - RClone Google Drive OAuth`.
- Browser access for Google auth (or a second machine for `rclone authorize`).

## 1. Create the remote

```sh
rclone config
# n (new remote) > name `gdrive` > Storage `drive`
# client_id / client_secret > your own OAuth client, see
# docs/runbooks/rclone-drive-client-id.md (the shared rclone ID is retired)
# scope > 1 (full drive access) > leave the rest default
# auto-auth > Y, sign in as the Drive account in the browser
```

The name must be `gdrive`: the service unit and hook hardcode `gdrive:notes`.

## 2. Confirm the folder is visible

```sh
rclone lsf gdrive:notes
```

Expect the vault listing. If the folder is missing or empty, stop: the hook skips the first resync against an empty Drive side. Fix the Drive side first.

## 3. Run the first sync from a login session

```sh
dcli sync
```

This performs `--resync` with Drive winning and enables `rclone-notes.timer`. Run it from a graphical or SSH login session, not under `sudo`: without a systemd user bus the hook prints a manual `systemctl --user` fallback instead of enabling the timer.

## 4. Verify

```sh
systemctl --user is-enabled rclone-notes.timer
systemctl --user list-timers rclone-notes.timer
ls ~/notes
```

Then trigger one sync and check it:

```sh
systemctl --user start rclone-notes.service
journalctl --user -u rclone-notes.service --no-pager | tail -5
```

## Troubleshooting

- Hook says no `gdrive` remote: step 1 did not complete; re-run `rclone config` and check `rclone listremotes`.
- Hook says Drive folder looks empty: the folder is missing or not yet propagated; see step 2.
- Hook says no user bus: run the printed `systemctl --user daemon-reload && systemctl --user enable --now rclone-notes.timer` from a login session.
- Sync aborts demanding `--resync`: see `docs/services.md` (never use `--check-access`; markers are not created on this rclone version).

## References

- `docs/runbooks/rclone-drive-client-id.md`
- `docs/services.md#notes-sync-timer`
