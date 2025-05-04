# macho-link-against-executable
Demo code and methods for linking against a MachO executable as if it was a library in order to use exported symbols

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
