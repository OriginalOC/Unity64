#!/bin/sh
echo "==> Unity64: Combine firmware images"

if command -v cmd.exe >/dev/null 2>&1; then
  cmd.exe /c "5- CombineImages.bat"
else
  echo "ERROR: Combine step is currently Windows-based."
  echo "       Run '5- CombineImages.bat' on Windows, or extend this script."
  exit 1
fi
