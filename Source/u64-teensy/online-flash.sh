#!/usr/bin/env sh
#
# online-flash.sh
#
# Placeholder / template for remote or "online" flashing of the Unity64
# Teensy firmware.  This script is intentionally *non-destructive* by default.
#
# The Makefile calls this script as:
#
#   ./online-flash.sh /path/to/Unity64-TeensyFW.hex
#
# Integrators are expected to replace the body of this file with their own
# logic (SSH copy, HTTP upload, custom bridge, etc.) while keeping the call
# signature intact.

set -eu

HEX_PATH="${1:-}"

if [ -z "${HEX_PATH}" ]; then
  echo "online-flash.sh: no firmware path provided" >&2
  exit 1
fi

echo "Unity64-TeensyFW online flashing placeholder"
echo "--------------------------------------------"
echo "Would now push and flash firmware:"
echo "  ${HEX_PATH}"
echo
echo "No action was taken. To integrate with your environment, edit"
echo "online-flash.sh and add the necessary upload / trigger logic."
