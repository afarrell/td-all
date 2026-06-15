#!/usr/bin/env bash
# td-all installer — symlinks the script into ~/.local/bin and seeds the config.
# Idempotent: safe to re-run. Never overwrites an existing config.
set -euo pipefail

# Repo root = the directory this script lives in (resolve through symlinks).
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/td-all"
CONFIG_FILE="${CONFIG_DIR}/config"

mkdir -p -- "${BIN_DIR}" "${CONFIG_DIR}"

# 1. Symlink the executable. -f replaces a stale link; -n avoids descending into
#    an existing symlinked dir target.
ln -sfn -- "${SCRIPT_DIR}/td-all" "${BIN_DIR}/td-all"
echo "Linked ${BIN_DIR}/td-all -> ${SCRIPT_DIR}/td-all"

# 2. Seed config from the example only if absent — never clobber a real config.
if [[ -f "${CONFIG_FILE}" ]]; then
  echo "Config already present at ${CONFIG_FILE} (left untouched)"
else
  cp -- "${SCRIPT_DIR}/config.example" "${CONFIG_FILE}"
  echo "Created ${CONFIG_FILE} from config.example — edit it to list your project roots"
fi

# 3. PATH check — warn (don't fail) if ~/.local/bin isn't reachable.
case ":${PATH}:" in
  *":${BIN_DIR}:"*) ;;
  *) echo "Note: ${BIN_DIR} is not on your PATH. Add it to run 'td-all' directly." ;;
esac

echo "Done. Run 'td-all' from anywhere inside a project tree."
