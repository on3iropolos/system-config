# Dotfiles

Four modules manage dotfiles: `noctalia` for the desktop shell, and `git`, `ssh`,
and `fish` for the shared command-line identity and login shell.

## How syncing works

dcli manages dotfiles as GNU Stow-style symlinks, not copies. Editing the
managed file at its real path edits the repository file and shows up as a
working-tree change. An existing file is backed up before dcli replaces it with
a symlink, and two modules claiming the same target is a hard error.

`dotfiles_sync: true` only auto-maps directories from `dotfiles/` to
`~/.config/<name>`, so it cannot reach `~/.ssh` or `~/.gitconfig`. Modules that
need those paths declare explicit `source` and `target` pairs instead. Explicit
sources are relative to the module root.

`dcli sync --prune` removes dotfiles belonging to disabled modules. Disabling
`git`, `ssh`, or `fish` on a host removes its symlink from that host.

## Noctalia and Umbriel sync

`modules/noctalia/module.yaml` sets `dotfiles_sync: true` with one explicit mapping.

```yaml
dotfiles_sync: true
dotfiles:
  - source: dotfiles/noctalia
    target: ~/.config/noctalia
```

Source directory `modules/noctalia/dotfiles/noctalia/` syncs to `~/.config/noctalia/`.
Noctalia v5 reads every `*.toml` file there, so the managed file is `config.toml`.
GUI overrides live in `~/.local/state/noctalia/settings.toml` and always win.
See the [Noctalia configuration reference](https://docs.noctalia.dev/noctalia/configuration/) for all keys.

`modules/noctalia/dotfiles/umbriel/config.toml` syncs to
`~/.config/umbriel/config.toml`. It autostarts Noctalia and defines the standard
Noctalia launcher, control-center, settings, window-switcher, audio, and
brightness shortcuts. Its `eDP-1` output policy configures stump's internal
3000x2000 panel at 1.5 scale.

## Git identity sync

`modules/git/dotfiles/gitconfig` symlinks to `~/.gitconfig` on both machines and
sets the shared account name, email, and default branch.

Because the file is a symlink, `git config --global` writes directly into this
repository. That is the intended declarative behaviour, but it also means a
stray global edit turns into an uncommitted change here.

## SSH client sync

`modules/ssh/dotfiles/config` symlinks to `~/.ssh/config` on both machines and
declares the `github.com` host with `IdentityFile ~/.ssh/on3iropolos-ssh`,
`IdentitiesOnly yes`, and `AddKeysToAgent 4h`.

`IdentitiesOnly` stops OpenSSH from offering unrelated keys that happen to sit in
`~/.ssh`. `AddKeysToAgent 4h` caches the unlocked key for four hours, so the
passphrase is normally entered once per reboot instead of once per terminal.

### Key material stays manual

Private keys are never committed and never managed by dcli. Each machine
generates its own key pair at `~/.ssh/on3iropolos-ssh` and registers only the
public half on the GitHub account, so the two hosts can be revoked
independently and neither compromise exposes the other.

OpenSSH refuses to load a private key that other users can read. Run
`chmod 600 ~/.ssh/on3iropolos-ssh` after generating it; a key left at mode
`0644` fails with an `UNPROTECTED PRIVATE KEY FILE` warning. The root
`.gitignore` guards the dotfiles directories against committing key files by
accident, but that guard only covers the known naming patterns.

## fish sync

`modules/fish/dotfiles/conf.d/ssh-agent.fish` symlinks to
`~/.config/fish/conf.d/ssh-agent.fish` on both machines. fish auto-loads every
`*.fish` file in `conf.d/`, so this fragment stays separate from each machine's
own `config.fish` and keeps host-specific content such as the CachyOS shell
config out of the shared layer.

The fragment starts an `ssh-agent` when none is reachable and adds
`~/.ssh/on3iropolos-ssh` to it. fish cannot call `eval` during startup, so the
agent output is captured with `string match` rather than
`eval "$(ssh-agent -s)"`; the latter fails at startup and leaks an agent process.
A socket left behind by a killed agent is treated as missing and restarted.

## Commands

```bash
noctalia config validate ~/.config/noctalia/config.toml
dcli sync --dry-run
dcli sync
dcli sync --force-dotfiles
dcli sync --prune
```

Validate a symlink landed where it should before trusting it:

```bash
ls -l ~/.ssh/config ~/.gitconfig ~/.config/fish/conf.d/ssh-agent.fish
```