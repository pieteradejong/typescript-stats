#!/usr/bin/env bash
# test.sh — every check in one place. Exit 0 = all green. `./run.sh test` runs this script.
#   ./test.sh            deps · secrets · shell · types (tsc --noEmit) · compile (tsc into a scratch dir)
# No test runner is configured in this repo; the type check and a clean compile are the checks.
set -euo pipefail
cd "$(dirname "$0")"
TSC_PKG="typescript@5.9.3"
case "${1:-}" in
  -h|--help) sed -n '2,4p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  '') ;;
  *) echo "test.sh: unknown option '$1' (see ./test.sh --help)" >&2; exit 2 ;;
esac

echo "== deps"
[ -d node_modules ] || npm ci --no-fund --no-audit
npm ls --depth=0 >/dev/null

echo "== secrets (no tracked .env)"
tracked="$(git ls-files | grep -E '(^|/)\.env(\..+)?$' | grep -vE '\.env\.(example|template)$' || true)"
[ -z "$tracked" ] || { echo "env files must never be tracked:"; echo "$tracked"; exit 1; }

echo "== shell"
for f in ./*.sh; do bash -n "$f"; /bin/bash -n "$f"; done
if command -v shellcheck >/dev/null 2>&1; then shellcheck -S warning ./*.sh; else echo "shellcheck not installed — syntax only"; fi

echo "== types (tsc --noEmit)"
npx --yes --package "$TSC_PKG" tsc --noEmit -p .

echo "== compile (tsc into a scratch dir; build/ is tracked and stays untouched)"
out="$(mktemp -d "${TMPDIR:-/tmp}/tsc-check.XXXXXX")"
trap 'rm -rf "$out"' EXIT
npx --yes --package "$TSC_PKG" tsc -p . --outDir "$out"
echo "== all green"
