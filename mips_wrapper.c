#include <stdio.h>

extern int foo(void);

int main(void)
{
    printf("%i\n", foo());

    return 0;
}
