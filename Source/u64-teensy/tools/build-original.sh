#!/bin/sh
echo "==> Unity64: Set Original (MinimalBoot) firmware configuration"

if command -v cmd.exe >/dev/null 2>&1; then
  cmd.exe /c "3- Set Original.bat"
else
  echo "ERROR: Original build is currently Windows-based."
  echo "       Run '3- Set Original.bat' on Windows, or extend this script."
  exit 1
fi
