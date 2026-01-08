#!/usr/bin/env sh
set -eu

echo "Running CI test harness..."

echo "+ autoreconf -fi"
autoreconf -fi

echo "+ ./configure"
./configure

echo "+ make doctor"
make doctor

echo "+ make upper"
make upper

echo "+ make original"
make original

echo "+ make combine"
make combine

if [ ! -f "TeensyROM_full.hex" ]; then
  echo "ERROR: combined hex TeensyROM_full.hex not found"
  exit 1
fi

echo "First build complete. Checking determinism..."

cp TeensyROM_full.hex TeensyROM_full.1.hex

echo "+ make clean"
make clean

echo "+ autoreconf -fi (second run)"
autoreconf -fi

echo "+ ./configure (second run)"
./configure

echo "+ make upper"
make upper

echo "+ make original"
make original

echo "+ make combine"
make combine

cp TeensyROM_full.hex TeensyROM_full.2.hex

echo "Comparing combined firmware images..."
cmp TeensyROM_full.1.hex TeensyROM_full.2.hex

echo "Determinism check passed."

echo "Scanning build system for forbidden .NET tool references..."
if grep -R "HexCombine.exe" Makefile.am configure.ac; then
  echo "ERROR: Found HexCombine.exe reference in Autotools build system"
  exit 1
fi

echo "CI test harness completed successfully."

echo "Skipping flashing tests (not required for CI)"
