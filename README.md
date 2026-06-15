# td-all

Show open `td` tasks across every project directory in one view.

`td-all` discovers `.todos` databases by:

1. Walking from `$PWD` up to `$HOME`, collecting any `.todos` dirs along the way.
2. Reading project roots from `~/.config/td-all/config` and scanning each root plus its immediate children.

Results are de-duplicated and printed grouped by project, with each task tagged by its source directory.

## Install

```sh
git clone git@github.com:afarrell/td-all.git ~/Projects/td-all
~/Projects/td-all/install.sh
```

`install.sh` is idempotent — it symlinks `td-all` into `~/.local/bin` and, if you don't already have one, seeds `~/.config/td-all/config` from `config.example`. Re-run it any time; it never overwrites an existing config.

Make sure `~/.local/bin` is on your `PATH`.

## Configure

Edit `~/.config/td-all/config` — one directory per line, `~` is expanded, `#` starts a comment. See [`config.example`](config.example) for the defaults.

## Usage

```sh
td-all                 # all open tasks across discovered projects
td-all [td list flags] # extra args are passed through to `td list`
```
