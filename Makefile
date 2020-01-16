# For Debian 10 Buster with the MIPS cross compiler toolchain (GCC)

MIPS_VERSION := -mips1

all: mips

mips: mips.o mips_wrapper.o
	mips-linux-gnu-gcc $(MIPS_VERSION) -o mips mips.o mips_wrapper.o

mips.o: mips.S
	mips-linux-gnu-gcc -c $(MIPS_VERSION) -mfp32 -o mips.o mips.S

mips_wrapper.o: mips_wrapper.c
	mips-linux-gnu-gcc -c $(MIPS_VERSION) -mfp32 -o mips_wrapper.o mips_wrapper.c

clean:
	rm mips *.o

.POHNY: clean
