# Teensy Firmware Build Tools

This directory contains helper tools used to build the Unity64 Teensy firmware.

The firmware is built as a **dual-boot image**, composed of two separately compiled firmware builds that are later combined into a single HEX file.

## Overview

The build process produces:

- **Upper firmware** – the main Unity64 firmware
- **Original firmware** – a minimal boot / fallback firmware

Each firmware uses different linker and boot configuration files and must be compiled separately.

## BootLinkerFiles

This directory contains alternate boot data and linker scripts used during the two build stages.

Files in this directory are swapped depending on whether the Upper or Original firmware is being built.

## Build Helper Scripts

The following scripts assist with build configuration:

- Scripts that prepare the environment for the **Upper** build
- Scripts that prepare the environment for the **Original** build
- Scripts that invoke the final image combination step

These scripts do not compile the firmware themselves; compilation is performed using the Arduino IDE or arduino-cli.

## Image Combination

After both firmware images are built, they are merged into a single final HEX file using the HexCombine utility.

This combined image is the one flashed to the Teensy.

## Important Notes

- This is a multi-stage build process
- A single-pass build is not sufficient
- Any future build system must preserve this structure
