TARGETS := test-exe libtest-lib.dylib stest-exe libstest-lib.dylib libstest-shim.dylib

C_CXX_FLAGS := -g -Wall -Wextra -Wpedantic
C_FLAGS := $(C_CXX_FLAGS) -std=gnu2x

all: $(TARGETS)

.PHONY: clean-targets clean-compile-commands clean clean-all compile_commands.json

clean-targets:
	rm -rf *.dSYM/
	rm -f $(TARGETS)

clean-compile-commands:
	rm -f compile_commands.json

clean: clean-targets

clean-all: clean clean-compile-commands

compile_commands.json:
	bear -- $(MAKE) -B -f $(MAKEFILE_LIST) RUNNING_BEAR=1
	$(MAKE) -f $(MAKEFILE_LIST) clean-targets

test-exe: test-exe.c test-exe.h test-lib.h libtest-lib.dylib
	$(CC) -o $@ test-exe.c $(C_FLAGS) libtest-lib.dylib

libtest-lib.dylib: test-lib.c test-lib.h test-exe.h tbds/test-exe.tbd
	$(CC) -shared -o $@ test-lib.c $(C_FLAGS) tbds/test-exe.tbd

stest-exe: stest-exe.c stest-exe.h stest-lib.h libstest-lib.dylib
	$(CC) -o $@ stest-exe.c $(C_FLAGS) libstest-lib.dylib

libstest-lib.dylib: stest-lib.c stest-lib.h stest-exe.h libstest-shim.dylib tbds/stest-exe.tbd
	$(CC) -shared -o $@ stest-lib.c $(C_FLAGS) libstest-shim.dylib tbds/stest-exe.tbd

libstest-shim.dylib: stest-shim.c tbds/stest-exe.tbd
	$(CC) -shared -o $@ stest-shim.c $(C_FLAGS) -Wno-empty-translation-unit -reexport_library tbds/stest-exe.tbd
