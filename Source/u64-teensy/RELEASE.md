# Release Engineering — Unity64‑TeensyFW

This document defines how firmware releases are built and published for the
Unity64 Teensy 4.1 firmware.

## Goals

- produce reproducible firmware artifacts
- ensure both firmware profiles ship
- ensure combined hex ships for legacy pipelines
- ensure CI can verify builds without hardware

## Versioning

Releases follow semantic versioning: `MAJOR.MINOR.PATCH`.

Tag examples:

```
v0.1.0
v0.2.0
```

## Required Artifacts

Each release must contain:

```
Unity64-TeensyFW.hex
MinimalBoot.hex
TeensyROM_full.hex
```

Optional packaging:

```
Unity64-TeensyFW-<ver>.tar.gz
Unity64-TeensyFW-<ver>-git.tar.gz
```

## Build Procedure

```
./bootstrap.sh
./configure
make distclean
make
```

Verify artifacts in:

```
build-upper/
build-original/
```

## Flash Validation (Optional)

For physical validation on hardware:

```
make flash
```

## CI Behavior

CI:

- installs toolchains
- builds firmware
- uploads artifacts
- never flashes hardware

## Combined Hex Rationale

`TeensyROM_full.hex` preserves compatibility with old TeensyROM pipelines that
expect a single image. Modern systems may use separate profile images.

## Publishing

1. increment version
2. commit & tag using `vX.Y.Z`
3. push tags
4. let CI build & attach artifacts
5. write release notes

## Regression Handling

If UPPER fails but MinimalBoot works, safe flashing remains available.

If MinimalBoot fails, **do not publish** until corrected.
