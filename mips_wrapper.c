#include <stdio.h>
#include <stdlib.h>

extern int foo(void);
// dir: 0 for left, 1 for right
extern int bitwise_rotate(int num, unsigned int dir, unsigned int bits);

int main(void)
{
    printf("%i\n", foo());

    // Left shift all 32 bits
    int num = 0x00000001;
    for (int i = 0; i <= 36; i++) {
        int num_l = bitwise_rotate(num, 0, i);
        // Hexadecimal output since printf does not support binary output (per standard)
        printf("bitwise_rotate(%i, 0, %i) = %x\n", num, i, num_l);
    }

    // Right shift all 32 bits
    num = 0x00000001;
    for (int i = 0; i <= 36; i++) {
        int num_l = bitwise_rotate(num, 1, i);
        printf("bitwise_rotate(%i, 1, %i) = %x\n", num, i, num_l);
    }

    // Size of int on this platform
    printf("sizeof(int) = %i\n", sizeof(int));

    return 0;
}
