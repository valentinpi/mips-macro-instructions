# For Debian 10 Buster with the MIPS cross compiler toolchain (GCC)

CC := mips-linux-gnu-gcc
MIPS_VERSION := -mips1

all: mips

mips: mips.o mips_wrapper.o
	$(CC) $(MIPS_VERSION) -o mips mips.o mips_wrapper.o

mips.o: mips.S
	$(CC) -c $(MIPS_VERSION) -mfp32 -o mips.o mips.S

mips_wrapper.o: mips_wrapper.c
	$(CC) -c $(MIPS_VERSION) -mfp32 -o mips_wrapper.o mips_wrapper.c

clean:
	rm mips *.o

.POHNY: clean
