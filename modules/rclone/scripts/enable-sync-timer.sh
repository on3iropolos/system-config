#!/usr/bin/env bash
# purpose: enable the rclone-notes user timer for the ~/notes bisync
# distro: any with systemd user units
# runs as: user (dcli post_install_hook, run_hooks_as_user: true)
# idempotent: yes (mkdir -p, guarded first resync, enable --now is a no-op when active)
# calling hook: rclone post_install, behavior always
set -euo pipefail

NOTES_DIR="${HOME}/notes"
SENTINEL="${HOME}/.cache/rclone-notes.initial-resync-done"

mkdir -p "${NOTES_DIR}"

if ! command -v rclone >/dev/null 2>&1; then
  echo "enable-sync-timer: rclone is not installed yet; sync the rclone module first." >&2
  exit 1
fi

if ! rclone listremotes 2>/dev/null | grep -qx 'gdrive:'; then
  cat >&2 <<'EOF'
enable-sync-timer: no 'gdrive' remote found, skipping the first sync.
To authenticate, run:
  rclone config   # n) new remote, name 'gdrive', storage 'drive', defaults otherwise
Then re-run 'dcli sync' to perform the first resync and start the timer.
EOF
else
  if [[ ! -f "${SENTINEL}" ]]; then
    # Never auto-resync against an empty Drive side: a move or API hiccup
    # up there must not mirror emptiness down into ~/notes.
    if [[ -z "$(rclone lsf 'gdrive:notes' --max-depth 1 2>/dev/null)" ]]; then
      cat >&2 <<'EOF'
enable-sync-timer: 'gdrive:notes' looks empty, skipping the first resync.
Verify the Drive folder, then re-run 'dcli sync'.
EOF
    else
      # No --check-access here: the check files only exist after a first
      # resync, and the local side is legitimately empty on fresh hosts.
      rclone bisync "gdrive:notes" "${NOTES_DIR}" --resync --resync-mode path1 --create-empty-src-dirs
      mkdir -p "$(dirname "${SENTINEL}")"
      touch "${SENTINEL}"
    fi
  fi
fi

if systemctl --user show-environment >/dev/null 2>&1; then
  systemctl --user daemon-reload
  systemctl --user enable --now rclone-notes.timer
  echo "enable-sync-timer: rclone-notes.timer enabled."
else
  cat >&2 <<'EOF'
enable-sync-timer: no systemd user bus here, leaving the timer for later.
Log in to a user session and run:
  systemctl --user daemon-reload && systemctl --user enable --now rclone-notes.timer
Optional, to run the timer without an active login:
  loginctl enable-linger "$USER"
Re-running 'dcli sync' from a login session enables it automatically.
EOF
fi
