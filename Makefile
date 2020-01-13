# For Debian 10 Buster with the MIPS cross compiler toolchain (GCC)

all: mips

mips: mips.o mips_wrapper.o
	mips-linux-gnu-gcc -mips32 -o mips mips.o mips_wrapper.o

mips.o: mips.asm
	mips-linux-gnu-as -mips32 -o mips.o mips.asm

mips_wrapper.o: mips_wrapper.c
	mips-linux-gnu-gcc -c -mips32 -o mips_wrapper.o mips_wrapper.c

clean:
	rm mips *.o

.POHNY: clean
