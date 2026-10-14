#!/usr/bin/env bash
# run.sh — TypeScript football-stats exercise. Run ./init.sh once first.
#   ./run.sh [start]     tsc --watch + nodemon build/index.js (default; Ctrl+C stops both)
#   ./run.sh build       compile once into build/
#   ./run.sh exec        run build/index.js once (compiles first)
#   ./run.sh test        every check (delegates to ./test.sh)
#   ./run.sh help
set -euo pipefail
cd "$(dirname "$0")"
TSC_PKG="typescript@5.9.3"

cmd="${1:-start}"
[ $# -gt 0 ] && shift
case "$cmd" in
  help|-h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  test) exec ./test.sh "$@" ;;
  start|build|exec) ;;
  *) echo "run.sh: unknown command '$cmd' (see ./run.sh help)" >&2; exit 2 ;;
esac
[ -d node_modules ] || { echo "node_modules missing: run ./init.sh first" >&2; exit 1; }
case "$cmd" in
  start)
    # package.json's start uses a global tsc; same shape, pinned compiler.
    npx --yes --package "$TSC_PKG" tsc -w -p . &
    tsc_pid=$!
    trap 'kill "$tsc_pid" 2>/dev/null' EXIT
    [ -f build/index.js ] || npx --yes --package "$TSC_PKG" tsc -p .
    npx nodemon build/index.js ;;
  build) exec npx --yes --package "$TSC_PKG" tsc -p . ;;
  exec)  npx --yes --package "$TSC_PKG" tsc -p . && exec node build/index.js ;;
esac
