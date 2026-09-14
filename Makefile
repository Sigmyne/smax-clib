# ===============================================================================
# WARNING! You should leave this Makefile alone probably
#          To configure the build, you can edit config.mk, or else you export the 
#          equivalent shell variables prior to invoking 'make' to adjust the
#          build configuration. 
# ===============================================================================

# Implicit directory in which to build libraries
LIB ?= lib

include config.mk

# ===============================================================================
# Specific build targets and recipes below...
# ===============================================================================

# The version of the shared .so libraries
SO_VERSION := 1

# Check if there is a doxygen we can run
ifndef DOXYGEN
  DOXYGEN := $(shell which doxygen)
else
  $(shell test -f $(DOXYGEN))
endif

# If there is doxygen, build the API documentation also by default
ifeq ($(.SHELLSTATUS),0)
  DOC_TARGETS += dox
endif

# Link against thread libs
LDFLAGS += -lpthread

# Build for distribution
.PHONY: distro
distro: warn $(LIBSMAX) tools $(DOC_TARGETS)

# Warn about limiting build options.
.PHONY: warn
warn:
ifndef DOC_TARGETS
	$(info WARNING! Doxygen is not available. Will skip 'dox' target)
endif

# Build everything...
.PHONY: all
all: warn static shared tools $(DOC_TARGETS) check

# Shared libraries (versioned and unversioned)
.PHONY: shared
shared: $(LIB)/libsmax.so 

# Legacy static libraries (locally built)
.PHONY: static
static: $(LIB)/libsmax.a

# Command-line tools
.PHONY: tools
tools: $(BIN)/smaxValue $(BIN)/smaxWrite

# Run regression tests
.PHONY: test
test: $(LIBSMAX) tools
	$(MAKE) -C test run

# Examples
.PHONY: examples
examples: $(LIBSMAX)
	$(MAKE) -C examples

# Build benchmark program
.PHONY: benchmark
benchmark: $(LIBSMAX)
	$(MAKE) -f test.mk benchmark

# 'test' + 'analyze'
.PHONY: check
check: test analyze

# Static code analysis via Facebook's infer
.PHONY: infer
infer: clean
	infer run -- $(MAKE) $(LIBSMAX)

# Remove intermediates
.PHONY: clean
clean:
	@rm -f $(OBJECTS) README-smax.md gmon.out
	@$(MAKE) -s -C test clean
	@$(MAKE) -s -C examples clean
	@$(MAKE) -s -C doc clean

# Remove all generated files
.PHONY: distclean
distclean: clean
	@rm -f $(LIB)/libsmax.so* $(LIB)/libsmax.a $(BIN)/smaxValue $(BIN)/smaxWrite
	@rm -rf build
	@$(MAKE) -s -C test distclean
	@$(MAKE) -s -C examples distclean
	@$(MAKE) -s -C doc distclean

# ----------------------------------------------------------------------------
# The nitty-gritty stuff below
# ----------------------------------------------------------------------------

SOURCES = $(SRC)/smax.c $(SRC)/smax-easy.c $(SRC)/smax-lazy.c $(SRC)/smax-queue.c \
          $(SRC)/smax-meta.c $(SRC)/smax-sub.c $(SRC)/smax-messages.c \
          $(SRC)/smax-resilient.c $(SRC)/smax-control.c $(SRC)/smax-util.c \
          $(SRC)/smax-tls.c $(SRC)/procname.c

# Generate a list of object (obj/*.o) files from the input sources
OBJECTS := $(subst $(SRC),$(OBJ),$(SOURCES))
OBJECTS := $(subst .c,.o,$(OBJECTS))

$(LIB)/libsmax.so: $(LIB)/libsmax.so.$(SO_VERSION)

# Shared library
$(LIB)/libsmax.so.$(SO_VERSION): $(SOURCES)

# Static library
$(LIB)/libsmax.a: $(OBJECTS)

README-smax.md: README.md
	LINE=`sed -n '/\# /{=;q;}' $<` && tail -n +$$((LINE+2)) $< > $@

.PHONY: dox
dox:
	$(MAKE) -C doc

# Some standard GNU targets, that should always exist...
.PHONY: html
html: local-dox

.PHONY: dvi
dvi:

.PHONY: ps
ps:

.PHONY: pdf
pdf:


# The package name to use for installation paths
PACKAGE_NAME ?= smax-clib

# Default values for install locations
# See https://www.gnu.org/prep/standards/html_node/Directory-Variables.html 
prefix ?= /usr
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
libdir ?= $(exec_prefix)/lib
includedir ?= $(prefix)/include
datarootdir ?= $(prefix)/share
datadir ?= $(datarootdir)
mandir ?= $(datarootdir)/man
mydatadir ?= $(datadir)/$(PACKAGE_NAME)
docdir ?= $(datarootdir)/doc/$(PACKAGE_NAME)
htmldir ?= $(docdir)/html

# Standard install commands
INSTALL_PROGRAM ?= install
INSTALL_DATA ?= install -m 644

.PHONY: install
install: install-libs install-tools install-man install-headers install-html

.PHONY: install-libs
install-libs:
ifneq ($(wildcard $(LIB)/*),)
	@echo "installing libraries to $(DESTDIR)$(libdir)"
	install -d $(DESTDIR)$(libdir)
	cp -a $(LIB)/* $(DESTDIR)$(libdir)/
else
	@echo "WARNING! Skipping libs install: needs 'shared' and/or 'static'"
endif

.PHONY: install-tools
install-tools:
ifneq ($(wildcard $(BIN)/*),)
	@echo "installing executable(s) under $(DESTDIR)$(bindir)."
	@install -d $(DESTDIR)$(bindir)
	$(INSTALL_PROGRAM) -D $(BIN)/* $(DESTDIR)$(bindir)/
else
	@echo "WARNING! Skipping tools install: needs 'tools'"
endif

.PHONY: install-man
install-man:
	@echo "installing man pages under $(DESTDIR)$(mandir)."
	@install -d $(DESTDIR)$(mandir)/man1
	$(INSTALL_DATA) -D man/man1/* $(DESTDIR)$(mandir)/man1

.PHONY: install-headers
install-headers:
	@echo "installing headers to $(DESTDIR)$(includedir)"
	install -d $(DESTDIR)$(includedir)
	$(INSTALL_DATA) -D include/smax.h $(DESTDIR)$(includedir)/

.PHONY: install-html
install-html:
ifneq ($(wildcard doc/html/search/*),)
	@echo "installing API documentation to $(DESTDIR)$(htmldir)"
	install -d $(DESTDIR)$(htmldir)/search
	$(INSTALL_DATA) -D doc/html/search/* $(DESTDIR)$(htmldir)/search/
	$(INSTALL_DATA) -D doc/html/*.* $(DESTDIR)$(htmldir)/
	@echo "installing Doxygen tag file to $(DESTDIR)$(docdir)"
	install -d $(DESTDIR)$(docdir)
	$(INSTALL_DATA) -D doc/*.tag $(DESTDIR)$(docdir)/
else
	@echo "WARNING! Skipping API doc install: needs doxygen and 'dox'"
endif

# Built-in help screen for `make help`
.PHONY: help
help:
	@echo
	@echo "Syntax: make [target]"
	@echo
	@echo "The following targets are available:"
	@echo
	@echo "  shared        Builds the shared 'libsmax.so' (linked to versioned)."
	@echo "  static        Builds the static 'lib/libsmax.a' library."
	@echo "  tools         Command line tools: 'bin/smaxValue' and 'bin/smaxWrite'."
	@echo "  local-dox     Compiles local HTML API documentation using 'doxygen'."
	@echo "  analyze       Performs static analysis with 'cppcheck'."
	@echo "  all           All of the above."
	@echo "  distro        shared libs and documentation (default target)."
	@echo "  install       Install components (e.g. 'make prefix=<path> install')"
	@echo "  clean         Removes intermediate products."
	@echo "  distclean     Deletes all generated files."
	@echo

# This Makefile depends on the config and build snipplets.
Makefile: config.mk build.mk

# ===============================================================================
# Generic targets and recipes below...
# ===============================================================================

include build.mk

