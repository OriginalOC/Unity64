## Makefile.am for Unity64-TeensyFW (Teensy 4.1 firmware)
##
## Directory: Source/u64-teensy

AUTOMAKE_OPTIONS = foreign subdir-objects

# Files that must be shipped in 'make dist' tarballs.
EXTRA_DIST = \
	u64-teensy.ino \
	MinimalBoot \
	Flash \
	TRMenuFiles \
	tools \
	BusSnoop.ino \
	SerUSBIO.ino \
	ServiceTCP.ino \
	README.md \
	online-flash.sh \
	bootstrap.sh

# --------------------------------------------------------------------
# Sketch locations
# --------------------------------------------------------------------

UPPER_SKETCH_DIR    = $(srcdir)
ORIGINAL_SKETCH_DIR = $(srcdir)/MinimalBoot

UPPER_SKETCH        = $(UPPER_SKETCH_DIR)/u64-teensy.ino
ORIGINAL_SKETCH     = $(ORIGINAL_SKETCH_DIR)/MinimalBoot.ino

# --------------------------------------------------------------------
# Build directories (inside build tree)
# --------------------------------------------------------------------

BUILDDIR_UPPER    = $(builddir)/build-upper
BUILDDIR_ORIGINAL = $(builddir)/build-original

# --------------------------------------------------------------------
# Firmware artifacts (Option A – human-friendly names)
# --------------------------------------------------------------------

UPPER_HEX_BASENAME    = Unity64-TeensyFW.hex
ORIGINAL_HEX_BASENAME = MinimalBoot.hex

UPPER_HEX    = $(BUILDDIR_UPPER)/$(UPPER_HEX_BASENAME)
ORIGINAL_HEX = $(BUILDDIR_ORIGINAL)/$(ORIGINAL_HEX_BASENAME)

# Combined HEX for legacy integration
COMBINED_HEX  = $(builddir)/TeensyROM_full.hex

ALL_HEX = $(UPPER_HEX) $(ORIGINAL_HEX) $(COMBINED_HEX)

# --------------------------------------------------------------------
# Tools from configure.ac (substituted by configure)
# --------------------------------------------------------------------

ARDUINO_CLI        ?= @ARDUINO_CLI@
ARDUINO_FQBN       ?= @ARDUINO_FQBN@
ARDUINO_MIN_FQBN   ?= @ARDUINO_MIN_FQBN@
TEENSY_LOADER_CLI  ?= @TEENSY_LOADER_CLI@
ARDUINO_DATA_DIR   ?= @ARDUINO_DATA_DIR@
TEENSY_CORE_PATH   ?= @TEENSY_CORE_PATH@
SREC_CAT           ?= @SREC_CAT@

RELEASE_NAME = Unity64-TeensyFW-$(PACKAGE_VERSION)

# --------------------------------------------------------------------
# Default 'all' target
# --------------------------------------------------------------------

all-local: $(UPPER_HEX) $(ORIGINAL_HEX) $(COMBINED_HEX)

.PHONY: upper original flash online-flash doctor clean-build release git-archive

upper: $(UPPER_HEX)
original: $(ORIGINAL_HEX)

# --------------------------------------------------------------------
# Core build rules
# --------------------------------------------------------------------

$(BUILDDIR_UPPER):
	$(MKDIR_P) "$(BUILDDIR_UPPER)"

$(BUILDDIR_ORIGINAL):
	$(MKDIR_P) "$(BUILDDIR_ORIGINAL)"

# UPPER firmware (USB Serial + MIDI)
$(UPPER_HEX): $(UPPER_SKETCH) | $(BUILDDIR_UPPER)
	@if test -z "$(ARDUINO_CLI)"; then \
	  echo "ERROR: arduino-cli not found (install or set ARDUINO_CLI)" >&2; \
	  exit 1; \
	fi; \
	echo "==> Unity64-TeensyFW: building UPPER firmware ($(notdir $(UPPER_SKETCH)) -> $(UPPER_HEX_BASENAME))"; \
	"$(ARDUINO_CLI)" compile \
	  --fqbn "$(ARDUINO_FQBN)" \
	  --output-dir "$(BUILDDIR_UPPER)" \
	  "$(UPPER_SKETCH)"; \
	HEXS=$$(ls "$(BUILDDIR_UPPER)"/*.hex 2>/dev/null || true); \
	if [ -z "$$HEXS" ]; then echo "ERROR: No .hex produced for UPPER" >&2; exit 1; fi; \
	FIRST=$$(echo "$$HEXS" | head -n1); \
	cp "$$FIRST" "$(UPPER_HEX)"

# MinimalBoot firmware (non-MIDI)
$(ORIGINAL_HEX): $(ORIGINAL_SKETCH) | $(BUILDDIR_ORIGINAL)
	@if test -z "$(ARDUINO_CLI)"; then \
	  echo "ERROR: arduino-cli not found (install or set ARDUINO_CLI)" >&2; \
	  exit 1; \
	fi; \
	echo "==> Unity64-TeensyFW: building MinimalBoot ($(notdir $(ORIGINAL_SKETCH)) -> $(ORIGINAL_HEX_BASENAME))"; \
	"$(ARDUINO_CLI)" compile \
	  --fqbn "$(ARDUINO_MIN_FQBN)" \
	  --output-dir "$(BUILDDIR_ORIGINAL)" \
	  "$(ORIGINAL_SKETCH)"; \
	HEXS=$$(ls "$(BUILDDIR_ORIGINAL)"/*.hex 2>/dev/null || true); \
	if [ -z "$$HEXS" ]; then echo "ERROR: No .hex produced for MinimalBoot" >&2; exit 1; fi; \
	FIRST=$$(echo "$$HEXS" | head -n1); \
	cp "$$FIRST" "$(ORIGINAL_HEX)"

# Generate full combined image (legacy-friendly)
$(COMBINED_HEX): $(UPPER_HEX) $(ORIGINAL_HEX)
	@if test -n "$(SREC_CAT)"; then \
	  echo "==> Generating combined image $(COMBINED_HEX) using srec_cat"; \
	  if "$(SREC_CAT)" "$(UPPER_HEX)" -Intel "$(ORIGINAL_HEX)" -Intel -o "$(COMBINED_HEX)" -Intel; then \
	    echo "==> Combined image generated OK"; \
	  else \
	    echo "WARNING: combined hex generation failed; using UPPER image only"; \
	    cp "$(UPPER_HEX)" "$(COMBINED_HEX)"; \
	  fi; \
	else \
	  echo "WARNING: srec_cat not found; using UPPER image as combined"; \
	  cp "$(UPPER_HEX)" "$(COMBINED_HEX)"; \
	fi

# --------------------------------------------------------------------
# Flashing workflows
# --------------------------------------------------------------------

flash: $(UPPER_HEX)
	@if test -z "$(TEENSY_LOADER_CLI)"; then \
	  echo "ERROR: teensy_loader_cli not available" >&2; exit 1; fi; \
	echo "==> Flashing Teensy via teensy_loader_cli"; \
	"$(TEENSY_LOADER_CLI)" -w "$(UPPER_HEX)"

online-flash: $(UPPER_HEX)
	@sh "$(srcdir)/online-flash.sh" "$(UPPER_HEX)"

# --------------------------------------------------------------------
# Doctor / diagnostics
# --------------------------------------------------------------------

doctor:
	@echo "Unity64-TeensyFW doctor"; \
	echo "-------------------------"; \
	echo "Arduino CLI     : $${ARDUINO_CLI:-@ARDUINO_CLI@}"; \
	echo "UPPER FQBN      : $(ARDUINO_FQBN)"; \
	echo "Minimal FQBN    : $(ARDUINO_MIN_FQBN)"; \
	echo "Loader (flash)  : $${TEENSY_LOADER_CLI:-@TEENSY_LOADER_CLI@}"; \
	echo "srec_cat        : $${SREC_CAT:-@SREC_CAT@}"

# --------------------------------------------------------------------
# Cleaning
# --------------------------------------------------------------------

clean-local:
	-rm -rf "$(BUILDDIR_UPPER)" "$(BUILDDIR_ORIGINAL)" "$(COMBINED_HEX)"

distclean-local: clean-local

maintainer-clean-local:
	@echo "==> maintainer-clean-local"
	-rm -rf autom4te.cache aclocal.m4 config.h.in config.h \
	    config.log config.status configure Makefile.in \
	    build-* *.hex TeensyROM_full.hex *.tar.gz *.zip

# --------------------------------------------------------------------
# Release helpers
# --------------------------------------------------------------------

release: distclean
	@echo "==> release $(RELEASE_NAME).tar.gz"
	-rm -rf "$(RELEASE_NAME)"
	mkdir -p "$(RELEASE_NAME)"
	tar -czf "$(RELEASE_NAME).tar.gz" \
	  --transform "s|^|$(RELEASE_NAME)/|" .

git-archive:
	@echo "==> git-archive"
	git archive --format=tar.gz \
	  --prefix="Unity64-TeensyFW-$(PACKAGE_VERSION)/" \
	  HEAD > "Unity64-TeensyFW-$(PACKAGE_VERSION)-git.tar.gz"
