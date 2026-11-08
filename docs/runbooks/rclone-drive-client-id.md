# Runbook: rclone Google Drive with own OAuth client ID

Google retires rclone's shared Drive client ID in 2026. Remotes using it stop working. Create your own Desktop OAuth client and use it in `rclone config`.

Applies to: personal Gmail, one user. No verification needed.

## Prerequisites

- Google account (any account; need not match the Drive account).
- `rclone` installed.
- Browser access on the machine running `rclone config` (or use `rclone authorize` remote flow).

## 1. Create project

1. Open `console.cloud.google.com`.
2. Top project picker > New Project. Name: `rclone-drive`. Create, then select it.

## 2. Enable Drive API

`APIs & Services > Library` > search `Google Drive API` > Enable.

Direct link: `console.cloud.google.com/flows/enableapi?apiid=drive.googleapis.com` (select same project).

## 3. Configure consent screen (new location)

Old rclone docs say `Credentials > Configure Consent Screen`. That screen is gone. Use:

`Google Auth platform > Branding` > `Get Started`:

1. App name: `rclone`. User support email: your email. Next.
2. Audience: `External`. Next.
3. Contact email: your email. Next.
4. Accept `Google API Services: User Data Policy`. Continue > Create.

Workspace-only use can use `Internal` instead, but then Drive must be in the same org.

## 4. Add scope

`Google Auth platform > Data Access > Add or Remove Scopes`:

- Add `https://www.googleapis.com/auth/drive`.
- Save.

This maps to rclone scope `drive` (full access except Application Data Folder). Personal use under 100 users does not need verification; you click through the unverified-app warning later.

## 5. Add test user

`Google Auth platform > Audience > Test users > Add users` > enter your Gmail (the Drive account) > Save.

## 6. Create OAuth client

`Google Auth platform > Clients > Create Client`:

- Application type: `Desktop app`.
- Name: `rclone`.
- Create. Copy Client ID (`*.apps.googleusercontent.com`) and Client Secret (`GOCSPX-...`).
- Store both in the Bitwarden Login item `Google API - RClone Google Drive OAuth` (ID as username, secret as password).

`Desktop app` is correct for rclone. Do not use `Web application`; rclone has no redirect URI to register.

## 7. Publish to avoid 7-day expiry

Left in `Testing`, grants expire after 7 days. Publish:

`Audience > Publish app > Confirm`.

If `Publish app` is disabled: `Branding` > set `Application home page`, `Application privacy policy link` (a GitHub Pages URL is fine), and `Authorized domains` (that domain) > Save > return to `Audience` and publish.

## 8. Configure rclone

```sh
rclone config
# n (new) > name `gdrive` (repo standard) > Storage `drive`
# client_id > paste your ID
# client_secret > paste your secret
# scope > 1 (drive)
# service_account_file > blank
# team drive > n (unless needed)
# auto-auth > Y, open browser link, sign in as test user,
# Advanced Settings > Continue (unverified app warning), Allow
```

Verify:

```sh
rclone lsd gdrive:
rclone about gdrive:
```

## Troubleshooting

- Wrong project: most common cause. Check top picker matches the project with the API + client.
- `redirect_uri_mismatch`: you picked `Web application`. Delete client, recreate as `Desktop app`.
- `Access blocked / unverified`: expected for personal clients. Click Advanced > Continue.
- `Token expired weekly`: app still in Testing. Do step 7.
- `Publish greyed out`: missing home page / privacy URL / domain in Branding. See step 7.
- Headless machine: answer `N` to browser auth, run `rclone authorize` on a machine with a browser per `rclone remote_setup` docs.

## References

- `developers.google.com/workspace/guides/configure-oauth-consent`
- `developers.google.com/workspace/guides/create-credentials`
- `developers.google.com/workspace/drive/api/quickstart/python` (Desktop app flow)
- `rclone.org/drive/#making-your-own-client-id`
