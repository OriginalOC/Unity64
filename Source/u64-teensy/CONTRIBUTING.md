# Contributing to Unity64‑TeensyFW Firmware

Thanks for your interest in contributing!

## Contribution Types

We accept contributions for:

- bug fixes
- build/tooling improvements
- documentation
- non‑breaking firmware features

We do **not** accept contributions that:

- remove the two‑profile firmware model
- hard‑bind flashing to specific transports
- break USB‑MIDI policy for UPPER firmware
- brick on boot failure

## Workflow

1. fork the project
2. create a feature branch
3. make changes
4. run builds locally
5. ensure artifacts compile
6. open a pull request

Example:

```
git checkout -b feature/foo
# … hack hack hack …
make
git push
```

## Build Verification

Before submitting, confirm:

```
make
make upper
make original
```

Optional local flashing:

```
make flash
```

## CI Expectations

CI must build without hardware present. CI uploads `.hex` artifacts only and
never flashes real devices.

## Licensing

By submitting a contribution, you agree to release it under the existing
project license unless explicitly negotiated.
