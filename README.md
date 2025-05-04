# macho-link-against-executable
Demo code and methods for linking against a MachO executable as if it was a library in order to use exported symbols

## Background

GraalVM, on Linux/ELF, creates native-image binaries with methods that normally reside in libjava.so instead reside in the native-image main executable (and are exported via the exe's dynamic symbols).

The native-image tool creates libjava.so and libjvm.so as `(jdk_library_shim)` which is just an empty translation unit that does nothing except prevent an error when other libraries like libawt.so that link against them are `dlopen()`ed.

This works because ELF dynamic linking is a bit looser and isn't two-level like Mach-O. The PLT stub for e.g. `JNU_GetEnv` in `libawt.so` naturally finds `JNU_GetEnv` inside the main executable without any extra work needed.

Mach-O with two-level namespaces means that `JNU_GetEnv` inside `libawt.dylib` really must *appear* to come from `libjava.dylib`. With Graal's current behavior, the empty stub `libjava.dylib` doesn't export any symbols and `JNU_GetEnv` inside `libawt.dylib` resolves to a NULL pointer and segfaults.

Using TBD files (libraries represented as text files) lets you work around ld not wanting to link dylibs against Mach-O executables. dyld has no qualms about such a configuration though and by making a `.tbd` file with the install path of the executable, ld thinks it is linking against a dylib and shuts up.

With ld's `-reexport_library` you can pass the TBD of the main executable and `JNU_GetEnv` inside `libawt.dylib` can now resolve into the main executable... once I patch up Graal to use this trick.

## Results

### Without stub shim

```console
->  % dyld_info -linked_dylibs -imports -exports test-exe libtest-lib.dylib
test-exe [arm64]:
    -linked_dylibs:
        attributes     load path
                       libtest-lib.dylib
                       /usr/lib/libSystem.B.dylib
    -exports:
        offset      symbol
        0x00000000  __mh_execute_header
        0x00000490  _fact
        0x00000504  _main
    -imports:
      0x0000  _fact_pretty  (from libtest-lib)
      0x0001  _printf  (from libSystem)
      0x0002  _strtoull  (from libSystem)
libtest-lib.dylib [arm64]:
    -linked_dylibs:
        attributes     load path
                       test-exe
                       /usr/lib/libSystem.B.dylib
    -exports:
        offset      symbol
        0x00000438  _fact_pretty
    -imports:
      0x0000  _fact  (from test-exe)
      0x0001  _printf  (from libSystem)
```

### With stub shim

```console
->  % dyld_info -linked_dylibs -imports -exports stest-exe libstest-lib.dylib libstest-shim.dylib
stest-exe [arm64]:
    -linked_dylibs:
        attributes     load path
                       libstest-lib.dylib
                       /usr/lib/libSystem.B.dylib
    -exports:
        offset      symbol
        0x00000000  __mh_execute_header
        0x00000490  _sfact
    -imports:
      0x0000  _sfact_pretty  (from libstest-lib)
      0x0001  _printf  (from libSystem)
      0x0002  _strtoull  (from libSystem)
libstest-lib.dylib [arm64]:
    -linked_dylibs:
        attributes     load path
                       libstest-shim.dylib
                       /usr/lib/libSystem.B.dylib
    -exports:
        offset      symbol
        0x00000440  _sfact_pretty
    -imports:
      0x0000  _sfact  (from libstest-shim)
      0x0001  _printf  (from libSystem)
libstest-shim.dylib [arm64]:
    -linked_dylibs:
        attributes     load path
        re-export      stest-exe
                       /usr/lib/libSystem.B.dylib
    -exports:
        offset      symbol
    -imports:
```
