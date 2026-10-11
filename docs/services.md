# Services

Minimal service and default-app policy for both hosts.

## Services

Both hosts enable only `NetworkManager`, which the distro installers provide.
Add services only with a package that provides them.

```yaml
services:
  enabled:
    - NetworkManager
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
  browser: brave
```

Capture live defaults before editing.

```bash
dcli merge --defaults
```

## Not yet covered

These land in a later pass with their provider packages and hooks.
Do not enable them by hand without the matching module change.

- `greetd` wired to `noctalia-greeter-session` plus an Umbriel Wayland session entry.
- `bluetooth` with `bluez` and `bluez-utils`.
