# Operations

How-to for daily dcli commands in this repository.

## First sync

```bash
dcli status
dcli sync
dcli validate
dcli status
```

Use this sequence for a blank system. The initial sync installs the packages
that provide configured default-application desktop files, so validation belongs
after the system has converged.

`stump` uses sequential module processing. dcli does not currently provide a
complete package preview for sequential `dcli sync --dry-run`; review
`dcli status` before running the initial sync instead.

## Capture existing unmanaged packages

Run merge only when deliberately adopting packages installed outside dcli. Do
not run it during a blank-system bootstrap, because it can capture installer
and setup packages that do not belong in this configuration.

```bash
dcli merge --dry-run
dcli merge
```

## Services and defaults

```bash
dcli merge --services
dcli merge --defaults
```

## Ongoing sync

```bash
dcli validate
dcli sync --dry-run
dcli sync
dcli status
```

Use `dcli sync --prune` only after reviewing the packages that would be
removed. On `stump`, the sequential-processing dry-run limitation still
applies.

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
