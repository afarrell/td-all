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
td-all                 # every open task across discovered projects
td-all [td list flags] # extra args are passed through to `td list`
td-all -n 10           # at most 10 tasks per project
```

### Limits

`td list` shows 50 tasks per project unless told otherwise. `td-all` asks for 100000 per project instead, so nothing is cut off. If you pass your own `-n`/`--limit`, it is passed to `td` unchanged and applies per project.

Whenever a project shows as many tasks as the limit in use, `td-all` prints a warning on stderr naming the project, because more may be hidden:

```
td-all: WARNING: ~/Projects/foo: 10 tasks shown, which is the limit in use (10); more may be hidden. Raise -n/--limit to see them.
```

Avoid `-n 0`: td 0.44 reads it as 50, while td 0.69 reads it as unlimited. `td-all` warns when `-n 0` returns exactly 50 tasks.

### Errors

If `td` fails for a project, `td-all` prints the error on stderr with the project name, carries on with the other projects, and exits 1 at the end:

```
td-all: ERROR in ~/Projects/foo: enable WAL mode: file is not a database (26)
```

Anything `td` writes to stderr on a successful run is also passed through as a warning with the project name.
