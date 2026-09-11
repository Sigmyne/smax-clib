LIB ?= ../lib
BIN ?= ../bin

include ../config.mk

# Flags for measuring test coverage
# Our own include directory
CPPFLAGS += -I../include
CFLAGS += -I../include -pg -Wall
LDFLAGS += -lm -lsmax -lredisx -lxchange -fprofile-arcs -ftest-coverage

# Check if a Redis / Valkey server is running for us
# to test on.
ONLINE ?= 0

REDIS = $(shell pidof redis-server)
ifneq ($(REDIS),)
  ONLINE = 1
endif

VALKEY = $(shell pidof valkey-server)
ifneq ($(VALKEY),)
  ONLINE = 1
endif

TESTS := simpleIntTest simpleIntsTest structTest queueTest lazyTest \
		lazyCacheTest waitTest controlTest resilientTest

.PHONY: all
all: run test-tools

.PHONY: tests
tests: $(TESTS)

.PHONY: run
run: tests
ifeq ($(ONLINE),1) 
	$(info INFO: [ONLINE] Will test client functionality.)
	./simpleIntTest
	./simpleIntsTest
	./structTest
	./queueTest
	./lazyTest
	./lazyCacheTest
	./waitTest
	./controlTest
endif

.PHONY: resilience
resilience:
ifeq ($(ONLINE),1) 
	./resilientTest
endif 

.PHONY: test-tools
ifeq ($(ONLINE),1) 
test-tools: test-int8 test-int16 test-int32 test-double test-string test-int-array
else
test-tools:
	$(warning INFO: [OFFLINE] tools integrity only.)
	../$(BIN)/smaxValue --help
	../$(BIN)/smaxWrite --help
endif

.PHONY: test-int8
test-int8: tools
	@echo $@
	@$(BIN)/smaxWrite -t int8 "_test_:tools:int8" 11
	@test `$(BIN)/smaxValue _test_:tools int8` -eq 11

.PHONY: test-int16
test-int16: tools
	@echo $@
	@$(BIN)/smaxWrite -t int16 "_test_:tools:int16" 2025
	@test `$(BIN)/smaxValue _test_:tools int16` -eq 2025

.PHONY: test-int32
test-int32: tools
	@echo $@
	@$(BIN)/smaxWrite -t int32 "_test_:tools:int32" 20250707
	@test `$(BIN)/smaxValue _test_:tools int32` -eq 20250707

.PHONY: test-float
test-float: tools
	@echo $@
	@$(BIN)/smaxWrite -t float "_test_:tools:float" 3.14
	@test `$(BIN)/smaxValue _test_:tools float` = 3.14

.PHONY: test-double
test-double: tools
	@echo $@
	@$(BIN)/smaxWrite -t double "_test_:tools:double" 3.14159265
	@test `$(BIN)/smaxValue _test_:tools double` = 3.14159265

.PHONY: test-string
test-string: tools
	@echo $@
	@$(BIN)/smaxWrite -t string "_test_:tools:string" abc
	@test `$(BIN)/smaxValue _test_:tools string` = abc

.PHONY: test-int-array
test-int-array: tools
	@echo $@
	@$(BIN)/smaxWrite -t int32 -d 4 "_test_:tools:numbers" "1,2,3,4"
	@test "`$(BIN)/smaxValue _test_:tools numbers | xargs`" = "1 2 3 4"

# Top level make targets...
.PHONY: build
build: $(TESTS)

.PHONY: tools
tools:
	$(MAKE) -C .. tools

.PHONY: benchmark
benchmark: $(BIN)/benchmark

$(BIN)/benchmark: LDFLAGS += -lpopt -lbsd

# Generic recipes
%Test: %Test.o $(OBJECTS) | Makefile
	@echo sources: $(SOURCES)
	@echo objects: $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)

%Test.o: %Test.c | Makefile
	$(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<

%.o: %.c | Makefile
	$(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) -fprofile-arcs -ftest-coverage $<

# Test coverage
.PHONY: coverage
coverage:
	$(MAKE) cov

cov: lcov.info
	genhtml $< -o $@

lcov.info:
	geninfo . -o $@
	lcov --remove $@ $(EXCLUDE_COV) -o $@

.PRECIOUS: %.c.gcov
%.c.gcov: %.gcno %.gcda
	gcov -b $*

.PRECIOUS: %.gcno %.gcda
%.gcno %.gcda: src/%.c
	$(MAKE) clean
	$(MAKE) run

# Cleanup
.PHONY: clean-test
clean-test:
	@rm -f $(TESTS)

.PHONY: clean-cov
clean-cov:
	@rm -rf gmon.out *.gcov *.gcda *.gcno cov cov.info

.PHONY: clean-data
clean-data:
	@rm -rf data

.PHONY: clean
clean: clean-test clean-cov
	@rm -f *.o

.PHONY: distclean
distclean: clean clean-data
	@rm -f lcov.info
	@rm -rf cov

# Help
.PHONY: help
help:
	@echo
	@echo "Syntax: make [target]"
	@echo
	@echo "The following targets are available:"
	@echo
	@echo "  run           (default) Compiles and runs regression tests."
	@echo "  test-tools    Check smaxWrite / smaxValue tools."
	@echo "  benchmark     Run benchmarks."
	@echo "  coverage      Extracts test coverage data."
	@echo "  analyze       Static analysis with cppcheck."
	@echo "  clean         Removes intermediate products."
	@echo "  distclean     Deletes all generated files."
	@echo

vpath %.c ../src