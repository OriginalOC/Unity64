AC_PREREQ([2.69])

AC_INIT([Unity64-TeensyFW], [0.1], [https://github.com/OriginalOC/Unity64/issues])
AM_INIT_AUTOMAKE([foreign subdir-objects -Wall])
AC_CONFIG_SRCDIR([u64-teensy.ino])
AC_CONFIG_HEADERS([config.h])

AC_CANONICAL_HOST

dnl --------------------------------------------------------------------
dnl  Toolchain discovery
dnl --------------------------------------------------------------------

AC_PROG_CC
AC_PROG_MAKE_SET

AC_ARG_VAR([ARDUINO_CLI],
  [Path to the arduino-cli executable used to build Teensy firmware])
AC_PATH_PROG([ARDUINO_CLI], [arduino-cli], [],
  [$PATH])

AC_ARG_VAR([TEENSY_LOADER_CLI],
  [Path to the teensy_loader_cli executable used for USB flashing])
AC_PATH_PROG([TEENSY_LOADER_CLI], [teensy_loader_cli], [],
  [$PATH])

dnl Optional Arduino data directory (sketchbook / packages)
AC_ARG_WITH([arduino-data],
  [AS_HELP_STRING([--with-arduino-data=DIR],
                  [Arduino CLI data directory (e.g. ~/.arduino15 or ~/.arduinoIDE)])],
  [ARDUINO_DATA_DIR="$withval"],
  [ARDUINO_DATA_DIR=""])

AC_SUBST([ARDUINO_DATA_DIR])

dnl --------------------------------------------------------------------
dnl  Teensy platform / FQBN selection
dnl --------------------------------------------------------------------

dnl Primary firmware (UPPER, USB Serial+MIDI)
AC_ARG_WITH([teensy-fqbn],
  [AS_HELP_STRING([--with-teensy-fqbn=FQBN],
                  [Arduino FQBN for Unity64 UPPER firmware (default: teensy:avr:teensy41:usb=serialmidi)])],
  [ARDUINO_FQBN="$withval"],
  [ARDUINO_FQBN="teensy:avr:teensy41:usb=serialmidi"])

dnl Minimal boot firmware (non-USB)
AC_ARG_WITH([teensy-min-fqbn],
  [AS_HELP_STRING([--with-teensy-min-fqbn=FQBN],
                  [Arduino FQBN for MinimalBoot firmware (default: teensy:avr:teensy41)])],
  [ARDUINO_MIN_FQBN="$withval"],
  [ARDUINO_MIN_FQBN="teensy:avr:teensy41"])

AC_SUBST([ARDUINO_FQBN])
AC_SUBST([ARDUINO_MIN_FQBN])

dnl Teensy core path is optional; arduino-cli normally manages cores itself.
AC_ARG_WITH([teensy-core-path],
  [AS_HELP_STRING([--with-teensy-core-path=DIR],
                  [Optional override for Teensy core tree used by legacy tools])],
  [TEENSY_CORE_PATH="$withval"],
  [TEENSY_CORE_PATH=""])

AC_SUBST([TEENSY_CORE_PATH])

dnl --------------------------------------------------------------------
dnl  Feature tests & soft failures
dnl --------------------------------------------------------------------

AS_IF([test -z "$ARDUINO_CLI"],
  [AC_MSG_WARN([arduino-cli was not found. \
You will need to provide ARDUINO_CLI when invoking make, \
and CI or packaging builds will fail until it is installed.])])

AS_IF([test -z "$TEENSY_LOADER_CLI"],
  [AC_MSG_WARN([teensy_loader_cli was not found. \
'make flash' will be unavailable on this host, \
but firmware builds and CI will still work.])])

dnl USB MIDI is required for the main firmware profile.  We do not fail
dnl configure here, but doctor(1) will flag a misconfigured FQBN.
AS_IF([echo "$ARDUINO_FQBN" | grep -q "usb=serialmidi"], [],
  [AC_MSG_WARN([ARDUINO_FQBN does not appear to use usb=serialmidi. \
The Teensy firmware may refuse to build until USB MIDI is enabled.])])

dnl Enable/disable flashing targets in Makefile
AM_CONDITIONAL([HAVE_TEENSY_LOADER_CLI],
  [test -n "$TEENSY_LOADER_CLI"])

dnl External utilities used by optional legacy workflows
AC_PATH_PROG([SREC_CAT], [srec_cat], [], [$PATH])
AC_SUBST([SREC_CAT])

dnl --------------------------------------------------------------------
dnl  Output
dnl --------------------------------------------------------------------

AC_CONFIG_FILES([
Makefile
])
AC_OUTPUT
