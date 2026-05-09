#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

CACHE_DIR=".cache"
JSON="$CACHE_DIR/exercises.json"
BASE_URL="https://raw.githubusercontent.com/yuhonas/free-exercise-db/main"

mkdir -p "$CACHE_DIR" images
[ -f "$JSON" ] || {
  echo "fetching exercise database..."
  curl -fsSL "$BASE_URL/dist/exercises.json" -o "$JSON"
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//'
}

missing=0
while IFS= read -r line; do
  case "$line" in
    ''|\#*) continue ;;
  esac
  if ! [[ "$line" =~ ^\"([^\"]+)\"[[:space:]]*=[[:space:]]*\"([^\"]+)\"[[:space:]]*$ ]]; then
    continue
  fi
  name="${BASH_REMATCH[1]}"
  id="${BASH_REMATCH[2]}"
  slug=$(slugify "$name")
  out="images/${slug}.jpg"

  if [ -f "$out" ]; then
    printf "  cached  %s\n" "$slug"
    continue
  fi

  rel=$(jq -r --arg id "$id" '.[] | select(.id == $id) | .images[0] // empty' "$JSON")
  if [ -z "$rel" ]; then
    printf "  MISSING %s (id '%s' not in db — try scripts/search.sh)\n" "$slug" "$id" >&2
    missing=$((missing + 1))
    continue
  fi

  printf "  fetch   %s  <-  %s\n" "$slug" "$id"
  curl -fsSL "$BASE_URL/exercises/$rel" -o "$out"
  magick "$out" -modulate 105,30,100 -sigmoidal-contrast 4,55% "$out"
  magick "$out" \
    \( +clone -resize 850x567^ -gravity center -extent 850x567 -blur 0x25 \) \
    +swap -resize 850x567 -gravity center -composite "$out"
done < mappings.toml

if [ "$missing" -gt 0 ]; then
  echo "$missing exercise(s) missing — fix mappings.toml" >&2
  exit 1
fi
