#!/usr/bin/env bash
# init.sh — everything needed to work on this TypeScript exercise. Idempotent; exit 0 = ready.
#   ./init.sh            node check, npm ci (reused when node_modules exists), warm the tsc cache
#   ./init.sh --clean    remove node_modules first
# typescript is not in package.json (pre-existing: `start:build` assumed a global tsc), so the
# scripts run a pinned compiler through npx; the first call downloads it into the npx cache.
set -euo pipefail
cd "$(dirname "$0")"
TSC_PKG="typescript@5.9.3"
case "${1:-}" in
  -h|--help) sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  --clean) rm -rf node_modules ;;
  '') ;;
  *) echo "init.sh: unknown option '$1' (see ./init.sh --help)" >&2; exit 2 ;;
esac

command -v npm >/dev/null 2>&1 || { echo "npm (Node 18+) is required" >&2; exit 1; }
echo "node $(node -v), npm $(npm -v)"
if [ -d node_modules ]; then
  echo "reusing node_modules (./init.sh --clean to rebuild)"
else
  npm ci --no-fund --no-audit
fi
echo "tsc $(npx --yes --package "$TSC_PKG" tsc -v)"
echo "ready: ./run.sh (watch + run) · ./test.sh (every check)"
