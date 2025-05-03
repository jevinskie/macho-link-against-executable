TARGETS := test-exe libtest-lib.dylib

C_CXX_FLAGS := -g -Wall -Wextra -Wpedantic
C_FLAGS := $(C_CXX_FLAGS) -std=gnu2x

all: $(TARGETS)

.PHONY: clean-targets clean-compile-commands clean compile_commands.json

clean-targets:
	rm -rf *.dSYM/
	rm -f $(TARGETS)

clean-compile-commands:
	rm -f compile_commands.json

clean: clean-targets clean-compile-commands

compile_commands.json:
	bear -- $(MAKE) -B -f $(MAKEFILE_LIST) RUNNING_BEAR=1
	$(MAKE) -f $(MAKEFILE_LIST) clean-targets

test-exe: test-exe.c test-exe.h test-lib.h
	$(CC) -o $@ test-exe.c $(C_FLAGS)

libtest-lib.dylib: test-lib.c test-lib.h test-exe.h
	$(CC) -shared -o $@ test-lib.c $(C_FLAGS)
