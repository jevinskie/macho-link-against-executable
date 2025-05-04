#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "stest-exe.h"
#include "stest-lib.h"

uint64_t sfact(uint64_t n) {
    uint64_t res = 1;
    if (n > 21) {
        return UINT64_MAX;
    }
    while (n > 1) {
        res *= n--;
    }
    return res;
}

int main(int argc, const char **argv) {
    if (argc != 2) {
        printf("usage: stest-exe <n for factorial>\n");
        return 1;
    }
    char *n_cend = NULL;
    uint64_t n   = strtoull(argv[1], &n_cend, 10);
    if (argv[1] == n_cend) {
        printf("stroull error input: '%s'\n", argv[1]);
        return 2;
    }
    sfact_pretty(n);
    return 0;
}
