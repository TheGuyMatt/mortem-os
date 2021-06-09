# mortem-os Makefile
#
# Author: Matthew Hieb
# Date Created: 2021-06-08
#
# Created with help from:
# https://wiki.osdev.org/Makefile
# https://github.com/jdah/tetris-os/blob/master/Makefile

UNAME := $(shell uname)

ifeq ($(UNAME),Linux)
	CC=gcc -elf_i386
	AS=as --32
	LD=ld -m elf_i386
else
	CC=i386-elf-gcc
	AS=i386-elf-as
	LD=i386-elf-ld
endif

# list of all non-source files
AUXFILES := Makefile README.md LICENSE

KERNEL_C_SRCS=$(wildcard src/*.c)
KERNEL_S_SRCS=$(wildcard src/*.s)
KERNEL_OBJS=$(KERNEL_C_SRCS:.c=.o) $(KERNEL_S_SRCS:.s=.o)

KERNEL=kernel.bin
ISO=mortem-os.iso

#PROJDIRS := src
#SRCFILES := $(shell find &(PROJDIRS) -type f -name "\*.c")
#HDRFILES := $(shell find &(PROJDIRS) -type f -name "\*.h")
#OBJFILES := $(patsubst %.c,%.o,$(SRCFILES))
#TSTFILES := $(patsubst %.c,%_t,$(SRCFILES))
#DEPFILES :=    $(patsubst %.c,%.d,$(SRCFILES))
#TSTDEPFILES := $(patsubst %,%.d,$(SRCFILES))
#ALLFILES := $(SRCFILES) $(HDRFILES) $(AUXFILES)

ALLFILES := $(KERNEL_C_SRCS) $(KERNEL_S_SRCS) $(AUXFILES)

#.PHONY: all clean dist check testdrivers todolist
.PHONY: all clean dist dirs kernel iso todolist

WARNINGS := -Wall -Wextra -pedantic -Wshadow -Wpointer-arith -Wcast-align \
						-Wwrite-strings -Wmissing-prototypes -Wmissing-declarations \
            -Wredundant-decls -Wnested-externs -Winline -Wno-long-long \
            -Wconversion -Wstrict-prototypes
CFLAGS := -std=gnu99 -ffreestanding -O2 $(WARNINGS)
LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc

all: dirs kernel

clean:
	rm -f ./**/*.o
	rm -f ./*.iso
	rm -f ./**/*.elf
	rm -f ./**/*.bin

dist:
	@tar czf mortem-os.tar.gzip $(ALLFILES)

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

%.o: %.s
	$(AS) -o $@ -c $<

dirs:
	mkdir -p build

kernel: $(KERNEL_OBJS)
	$(LD) -o ./build/$(KERNEL) $^ $(LDFLAGS) -Tsrc/linker.ld

# this command assumes you have grub installed
iso:
	echo "menuentry \"mortem-os\" {\n        multiboot /boot/kernel.bin\n}" > ./build/grub.cfg
	mkdir -p isodir/boot/grub
	cp kernel.bin isodir/boot/kernel.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o mortem-os.iso isodir

todolist:
	-@for file in $(ALLFILES:Makefile=); do fgrep -H -e TODO -e FIXME $$file; done; true