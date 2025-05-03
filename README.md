# macho-link-against-executable
Demo code and methods for linking against a MachO executable as if it was a library in order to use exported symbols

## Results

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
