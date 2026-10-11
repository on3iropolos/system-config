# Operations

How-to for daily dcli commands in this repository.

## First sync

```bash
dcli validate
dcli merge --dry-run
dcli sync --dry-run
dcli sync
```

## Services and defaults

```bash
dcli merge --services
dcli merge --defaults
```

## Ongoing sync

```bash
dcli sync --dry-run
dcli sync
dcli sync --prune
dcli status
```

## Modules

```bash
dcli module list
dcli module enable <name>
dcli module disable <name>
dcli find <package>
dcli validate
```

## Git workflow

GitHub at `git@github.com:on3iropolos/system-config.git` on `main` is the source of truth.
Plain `git` manages the checkout at `~/src/system-config`; `dcli repo` commands operate on the same tree via the `~/.config/arch-config` symlink.

```bash
dcli init
dcli repo init
dcli repo clone
dcli repo push
dcli repo pull
dcli repo status
```

## Two-machine flow

```bash
dcli merge --dry-run
dcli module enable <name>
dcli sync
dcli repo push
dcli repo pull
```
