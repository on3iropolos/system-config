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
  browser: brave-browser.desktop
```

Default applications use the installed `.desktop` file ID, not a package or
product name. `brave-bin` on CachyOS and `brave-browser` on Ubuntu provide
`brave-browser.desktop`.

Capture live defaults before editing.

```bash
dcli merge --defaults
```

## Not yet covered

These land in a later pass with their provider packages and hooks.
Do not enable them by hand without the matching module change.

- `greetd` wired to `noctalia-greeter-session` plus an Umbriel Wayland session entry.
- `bluetooth` with `bluez` and `bluez-utils`.

Follow the [Noctalia greeter installation](https://docs.noctalia.dev/greeter/installation/) when this pass lands: `greetd` must launch `noctalia-greeter-session` (not the `noctalia-greeter` binary) as user `greeter`, then enable `greetd` and disable the prior display manager.
