
# HACKING — Unity64-TeensyFW Firmware

This document explains how to modify, build, and extend the Teensy firmware
portion of Unity64. It is intended for developers familiar with firmware and
build systems, and assumes you are working from a git checkout.

This directory uses:

- **Autotools** for local & CI build orchestration
- **Arduino-CLI** for firmware compilation
- **Makefile targets** for flash & packaging
- **Two firmware profiles** with different policies

Contents:

1. Firmware Roles
2. Sketch Layout
3. Build System Model
4. USB MIDI Policy
5. Flash Workflows
6. CI Behavior
7. Adding or Modifying Code
8. Adding New Firmware Profiles
9. Combined HEX Logic
10. Cleanup & Releases
11. Repository Invariants

---

## 1. Firmware Roles

Unity64 firmware is split into two distinct pieces:

### UPPER (main coprocessor firmware)

- sketch: `u64-teensy.ino`
- requires: USB Serial + MIDI
- performs: Unity64 acceleration, IO handling, networking, menus, etc.
- runtime: long-lived

### MinimalBoot (bring-up firmware)

- sketch: `MinimalBoot/MinimalBoot.ino`
- does not require USB MIDI
- performs: fast safe boot, recovery, board sanity
- runtime: transient

---

## 2. Sketch Layout

```
u64-teensy.ino
MinimalBoot/
Flash/
TRMenuFiles/
tools/
BusSnoop.ino
SerUSBIO.ino
ServiceTCP.ino
```

---

## 3. Build System Model

```
./bootstrap.sh
./configure
make
```

Produces:

```
Unity64-TeensyFW.hex
MinimalBoot.hex
TeensyROM_full.hex
```

---

## 4. USB MIDI Policy

UPPER enforces:

```
#error "Unity64 UPPER requires USB MIDI"
```

MinimalBoot defines:

```
#define UNITY64_MINIMAL_BOOT 1
```

---

## 5. Flash Workflows

Local USB flashing:

```
make flash
```

Remote / CI / OTA:

```
make online-flash
```

`online-flash.sh` is intentionally transport-agnostic.

---

## 6. CI Behavior

CI:

- installs toolchains
- builds firmware
- uploads artifacts
- does not flash hardware

---

## 7. Adding or Modifying Code

Rules:

- do not stall USB in UPPER
- do not rely on combined hex for correctness
- do not break MinimalBoot independence
- do not assume local flashing

---

## 8. Adding New Firmware Profiles

Steps:

1. add new sketch
2. add Makefile target
3. add fqbn config in configure.ac
4. ship artifacts via CI

---

## 9. Combined HEX Logic

Generated via `srec_cat` if present, else falls back to UPPER-only.

---

## 10. Cleanup & Releases

Useful targets:

```
make clean
make distclean
make release
make git-archive
```

---

## 11. Repository Invariants

Must preserve:

- profile split
- USB MIDI enforcement only in UPPER
- CI artifact-only model
- Arduino-CLI toolchain
- Autotools orchestration
