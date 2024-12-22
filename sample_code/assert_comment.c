#include <stdio.h>
#include <assert.h>

typedef unsigned char uint8;

void main()
{
    uint8 log2_cu_size = 5;

    assert(5 > log2_cu_size && 2 < log2_cu_size);
    assert(("illegal CU size", 5 > log2_cu_size && 2 < log2_cu_size));

    printf("cu_size = %d", 1 << log2_cu_size);

    return;
}