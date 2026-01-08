#!/bin/sh
echo "==> Unity64: Set Upper firmware configuration"

if command -v cmd.exe >/dev/null 2>&1; then
  cmd.exe /c "1- Set Upper.bat"
else
  echo "ERROR: Upper build is currently Windows-based."
  echo "       Run '1- Set Upper.bat' on Windows, or extend this script."
  exit 1
fi
