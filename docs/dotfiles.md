# Dotfiles

Only the `noctalia` module manages dotfiles in this pass. It synchronizes both
the Noctalia shell and Umbriel compositor configuration.

## Noctalia and Umbriel sync

`modules/noctalia/module.yaml` sets `dotfiles_sync: true` with one explicit mapping.

```yaml
dotfiles_sync: true
dotfiles:
  - source: dotfiles/noctalia
    target: ~/.config/noctalia
```

Explicit dotfile sources are relative to the module root. Source directory
`modules/noctalia/dotfiles/noctalia/` syncs to `~/.config/noctalia/`.
Noctalia v5 reads every `*.toml` file there, so the managed file is `config.toml`.
GUI overrides live in `~/.local/state/noctalia/settings.toml` and always win.
See the [Noctalia configuration reference](https://docs.noctalia.dev/noctalia/configuration/) for all keys.

`modules/noctalia/dotfiles/umbriel/config.toml` syncs to
`~/.config/umbriel/config.toml`. It autostarts Noctalia and defines the standard
Noctalia launcher, control-center, settings, window-switcher, audio, and
brightness shortcuts.

## Commands

```bash
noctalia config validate ~/.config/noctalia/config.toml
dcli sync --dry-run
dcli sync
dcli sync --force-dotfiles
dcli sync --prune
```
