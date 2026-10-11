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
product name. `brave-bin` on CachyOS and `brave-browser` on Ubuntu provide
`brave-browser.desktop`.

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

## Not yet covered

- `bluetooth` with `bluez` and `bluez-utils`.
