#!/bin/sh
set -eu

# ------------------------------------------------------------
# Unity64 Teensy Arduino CLI build helper
#
# Usage:
#   arduino-build.sh <sketch.ino> <output.hex>
#
# Requirements:
#   - ARDUINO_CLI must point to the full arduino-cli binary
#   - Called from the Teensy source directory (where Teensy.ino lives)
#
# Notes:
#   - USB type is forced to Serial + MIDI via FQBN
# ------------------------------------------------------------

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <sketch.ino> <output.hex>" >&2
  exit 1
fi

SKETCH="$1"
OUT_HEX="$2"

if [ -z "${ARDUINO_CLI:-}" ]; then
  echo "ERROR: ARDUINO_CLI environment variable is not set." >&2
  echo "       Run ./configure, then 'make doctor' to verify, or export ARDUINO_CLI manually." >&2
  exit 1
fi

if [ ! -x "$ARDUINO_CLI" ]; then
  echo "ERROR: ARDUINO_CLI is not executable: $ARDUINO_CLI" >&2
  exit 1
fi

# Teensy 4.1 with USB type = Serial + MIDI
FQBN="teensy:avr:teensy41:usb=serialmidi"

# Use a build dir under the current tree so paths behave nicely under WSL + Windows
BUILD_DIR="$(pwd)/build-test-$$"
mkdir -p "$BUILD_DIR"

echo "==> Unity64 Arduino build"
echo "    Sketch:   $SKETCH"
echo "    Output:   $OUT_HEX"
echo "    FQBN:     $FQBN"
echo "    CLI:      $ARDUINO_CLI"
echo "    BuildDir: $BUILD_DIR"
echo ""

# Let arduino-cli figure out libraries and core from its config
"$ARDUINO_CLI" compile \
  --fqbn "$FQBN" \
  --output-dir "$BUILD_DIR" \
  --build-path "$BUILD_DIR" \
  "$SKETCH"

# Arduino CLI may emit more than one HEX; pick the primary one
HEX_FILE=$(ls "$BUILD_DIR"/*.hex 2>/dev/null | head -n 1 || true)

if [ -z "$HEX_FILE" ] || [ ! -f "$HEX_FILE" ]; then
  echo "ERROR: no HEX file produced in $BUILD_DIR" >&2
  exit 1
fi

cp "$HEX_FILE" "$OUT_HEX"

echo "==> Build complete: $OUT_HEX"
