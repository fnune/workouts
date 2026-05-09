#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

CACHE_DIR=".cache"
JSON="$CACHE_DIR/exercises.json"
BASE_URL="https://raw.githubusercontent.com/yuhonas/free-exercise-db/main"

mkdir -p "$CACHE_DIR"
[ -f "$JSON" ] || curl -fsSL "$BASE_URL/dist/exercises.json" -o "$JSON"

if [ $# -eq 0 ]; then
  echo "usage: $0 <search term>" >&2
  exit 1
fi

q="$*"
jq -r --arg q "$q" '
  .[]
  | select(.name | test($q; "i"))
  | "\(.id)\t\(.name)\t\(.equipment // "-")"
' "$JSON" | column -t -s $'\t'
