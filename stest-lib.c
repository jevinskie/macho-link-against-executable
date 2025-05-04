#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

#include "stest-exe.h"
#include "stest-lib.h"

void sfact_pretty(uint64_t n) {
    printf("sfact_pretty called with n: %" PRIu64 "\n", n);
    uint64_t r = sfact(n);
    printf("sfact_pretty: sfact(%" PRIu64 ") = %" PRIu64 "\n", r, n);
}
