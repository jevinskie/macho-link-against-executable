#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

#include "test-exe.h"
#include "test-lib.h"

void fact_pretty(uint64_t n) {
    printf("fact_pretty called with n: %" PRIu64 "\n", n);
    uint64_t r = fact(n);
    printf("fact_pretty: fact(%" PRIu64 ") = %" PRIu64 "\n", r, n);
}
