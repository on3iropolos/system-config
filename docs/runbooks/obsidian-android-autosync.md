# Runbook: Obsidian notes on Android via AutoSync

Sync the `notes` Obsidian vault from Google Drive to Android and open it in Obsidian Android. Ends with two-way sync verified.

## Prerequisites

- The Drive folder `/notes` holds the vault.
- Android phone with Play Store access.
- Google account with access to the Drive folder.
- Apps installed: `Autosync for Google Drive` and `Obsidian`.

## 1. Create the folder pair in AutoSync

1. Open AutoSync, sign in with the Google account, grant file access when asked.
2. Create a new folder pair with these values:
   - Folder Pair Name: `notes`
   - Remote Folder in Google Drive: `/notes`
   - Local Folder in Device: `[Internal Storage]/notes`
   - Sync Method: Two-way
3. Save, then run the first sync from inside AutoSync.
4. Confirm the local `notes` folder now holds the vault files (`.md` files, `.obsidian/`).

Start with an empty or missing local `notes` folder so the first download cannot conflict with stale files.

## 2. Open the vault in Obsidian

1. Open Obsidian Android.
2. Choose open folder as vault, select the local `notes` folder.
3. Grant storage access when asked.
4. Confirm the vault opens with existing notes visible.

## 3. Verify two-way sync

1. Create a test note on Android, wait for AutoSync to upload it.
2. Check it appears in Drive (`/notes`) and on your other devices.
3. Create a second test note in Drive or on another device, wait for AutoSync to download it.
4. Check it appears in Obsidian Android.
5. Delete both test notes once both directions work.

## Troubleshooting

- Vault opens empty: the wrong local folder was picked, or step 1 has not finished. Check the local `notes` contents in a file manager first.
- Files do not sync: check the folder pair is enabled in AutoSync and the Google account still has Drive access.
- Edits clash: AutoSync two-way can keep both copies on close edits. Pick the good copy, delete the other, let it sync through.
- Sync stops in background: exempt AutoSync from battery saving so it keeps running.
