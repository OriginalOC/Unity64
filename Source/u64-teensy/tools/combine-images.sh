#!/bin/sh
set -e

echo "==> Unity64: Combining firmware images using srec_cat"

# Expected inputs (match existing workflow)
UPPER_HEX="upper.hex"
ORIGINAL_HEX="original.hex"
OUTPUT_HEX="combined.hex"

# Sanity checks
if ! command -v srec_cat >/dev/null 2>&1; then
  echo "ERROR: srec_cat not found"
  echo "Install with:"
  echo "  sudo apt install srecord"
  echo "  brew install srecord"
  exit 1
fi

for f in "$UPPER_HEX" "$ORIGINAL_HEX"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: Missing input file: $f"
    exit 1
  fi
done

# Combine: last write wins on overlap (matches typical HexCombine behavior)
srec_cat \
  "$ORIGINAL_HEX" -Intel \
  "$UPPER_HEX"    -Intel \
  -o "$OUTPUT_HEX" -Intel

echo "==> Combined image written to: $OUTPUT_HEX"
