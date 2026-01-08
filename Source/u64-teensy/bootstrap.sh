#!/usr/bin/env sh
#
# Autotools bootstrap helper for Unity64-TeensyFW (Teensy firmware).
#
# Run this once from a git checkout:
#
#   ./bootstrap.sh
#   ./configure
#   make
#
# Release tarballs created via 'make dist' already contain a generated
# ./configure script and do not require this step.

set -eu

echo "+ autoreconf -fi"
autoreconf -fi
