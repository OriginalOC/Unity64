# Unity64

**Unity64** combines the classic Commodore 64 with modern Teensy-based acceleration, enhancing graphics, math processing, and real-time performance. It preserves full C64 compatibility while adding GPU assistance and advanced computation, creating a seamless hybrid computing platform.

## Overview

Unity64 is an evolution of the TeensyROM concept, which began as a ROM emulator, fast loader, and multifunction cartridge for Commodore 64/128 systems. It has grown into a true augmentation platform, extending the C64’s capabilities without replacing its identity or behavior.

This project focuses on:

- **Math Coprocessing**  
  Offloading heavy computations to the Teensy to enable advanced algorithms, transforms, and effects.

- **GPU Assistance**  
  Supporting the VIC-II with sprite multiplexing, raster timing, and graphics preparation without burdening the C64 CPU.

- **Smooth Integration**  
  Enhancements are designed to fit naturally within existing C64 software paradigms.

- **High Usability**  
  Menus, utilities, and workflows that feel responsive, predictable, and enjoyable to use.

Unity64 is not a PC, emulator, or alternate operating system. It is a hardware-accurate enhancement that honors the C64 while pushing what is possible on real hardware.

## Goals

- Bridge retro computing with modern acceleration
- Provide a clear, deterministic command interface between the C64 and Teensy
- Make advanced graphics and math approachable without changing the C64’s core identity
- Create a platform others can build games, demos, and tools on

## Getting Started

This repository contains multiple components, including:

- Firmware for the Teensy coprocessor
- C64-side code to interface with Teensy acceleration
- Documentation and design artifacts

See each subdirectory for component-specific build instructions (for example, Teensy firmware in `Source/Teensy`).

## Contributing

Unity64 welcomes contributions. Documentation improvements, demos, tooling, and coprocessor extensions are all encouraged.

## License

MIT
