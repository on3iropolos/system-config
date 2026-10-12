# Configuration

Explanation of the repository layout and conventions.
New dcli layout only: no `packages/` directory, no Lua, no Nix.

## Layout

Canonical checkout is `~/src/system-config` on every machine.
`~/.config/arch-config` is a symlink to it, because dcli hardcodes `~/.config/arch-config` on all distros (Arch and Ubuntu alike).
Remote source of truth is `git@github.com:on3iropolos/system-config.git` on branch `main`.

```text
~/src/system-config/
~/.config/arch-config -> ~/src/system-config
config.yaml
hosts/machine-serial.yaml
hosts/stump.yaml
hosts/shared/common.yaml
modules/<name>/module.yaml
modules/<name>/packages.yaml
modules/<name>/dotfiles/*
modules/<name>/scripts/*.sh
docs/*.md
```

## Conventions

- `config.yaml` is pointer-only with a per-machine switch comment.
- Edit the repo at `~/src/system-config`, never through the `~/.config/arch-config` symlink target confusion: both resolve to the same tree.
- Host files stay minimal with `packages: []` and shared settings in `hosts/shared/common.yaml`.
- Every package entry notes distro validity when names differ with `# apt: X | pacman: Y`.
- Every hook states behavior and user explicitly with `pre/post_hook_behavior` plus `run_hooks_as_user`.
- Hooks live in the owning module's `scripts/` directory and use idempotent
  `*_repo.sh` or `install-*.sh` scripts, never inline curl-pipes.
- Dotfiles live in the owning module's `dotfiles/` directory and declare explicit
  `source`/`target` pairs. Private key material is never committed; see
  [Dotfiles](dotfiles.md).
- One H1 per markdown file with strict ATX hierarchy and fenced blocks that always declare a language.
- Descriptive links in prose, never bare URLs or "click here"; fenced shell commands may contain raw URLs (Flathub, pacman `Server`, `git clone`).
- Every host, module, or script change needs a matching `docs/hosts.md` or `docs/modules.md` row.
- Every such change also needs a [CHANGELOG](../CHANGELOG.md) entry.
