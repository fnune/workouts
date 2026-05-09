#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p dist
shopt -s nullglob
files=(workouts/*.typ)
if [ ${#files[@]} -eq 0 ]; then
  echo "no workouts/*.typ files found" >&2
  exit 1
fi

for f in "${files[@]}"; do
  base=$(basename "$f" .typ)
  out="dist/${base}.pdf"
  printf "  build   %s\n" "$out"
  typst compile --root . "$f" "$out"
done
