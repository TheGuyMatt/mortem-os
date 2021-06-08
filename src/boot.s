/*
boot.s: multiboot assembly for mortem-os

Author: Matthew Hieb
Date Created: 2021-06-08

Created using the bare bones tutorial on wiki.osdev.org
https://wiki.osdev.org/Bare_Bones
*/

/* Declare constants for the multiboot header.  */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* multiboot flag field */
.set MAGIC,    0x1BADB002       /* magic number, lets bootloader find header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum, proves we are multiboot */

/*
Declare multiboot header, marks program as a kernel.
Magic values are documented in the multiboot standard.
Bootloader searches for this signature in first 8 KiB of kernel file,
aligned at a 32-bit boundary. Signature is in its own section
so the header can be forced to be within the first 8 KiB.
*/

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/*
It is the kernel's job to provide a stack and define pointer values.
This allocates room for a small stack, creating symbol at the bottom,
then allocating 16384 bytes for it, then creating symbol at the top.
Stack grows downwards on x86. The stack is in its own section so it
can be marked nobits, which means the kernel file is smaller because
it does not contain an unitialized stack. The stack on x86 must be
16-byte aligned. Compiler will assume this alignment.
*/
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/*
_start is the entry point to the kernel. The bootloader will jump to
this posistion once the kernel has been loaded. We do not return from
this function because the bootloader is gone once the kernel is loaded
*/
.section .text
.global _start
.type _start, @function
_start:
  /*
  Bootloader has loaded into 32-bit protected mode on a x86 machine.
  Inturrupts are disabled, paging is disabled. The processor state is
  as defined in the multiboot standard. The kernel has full control
  of the CPU. The kernel can only make use of hardware features.
  There is no printf function unless the kernel defines its own
  header and implementation of printf. No security restrictions, no
  safeguards, no debugging implementation. The kernel has absolute and
  complete power over the machine.
  */
  
  /*
  We setup a stack with the esp register to point to the top of the stack
  because it grows downwards in x86 systems. We do this in assembly because
  C needs a stack to function.
  */
  mov $stack_top, %esp

  /*
  We now have to initialize crucial processor states at this state of the
  kernel. We minimize the early environment but enable all necessary
  processor features before leaving it as the processor is not fully
  enabled/initialized yet.
  */

  /*
  Enter the high-level kernel. ABI requires that the stack is 16 byte
  aligned at the time we call this instruction. Because we have aligned
  the stack to 16 bytes already the call is well defined.
  */
  call kernel_main

  /*
  If the system has nothing more to do, we put the machine into an
  infinite loop. We do this by:
  1) Disable interrupts with cli (clears interrupt enable in eflags)
  2) Wait for next interrupt to arrive with hlt (halt instruction).
     Since they are disabled, this will lock the computer.
  3) Jump to hlt if it ever escapes the lock due to non-maskable
     interrupt or due to system management mode.
  */
  cli
  1: hlt
  jmp 1b

/*
Set the size of the _start symbol to the current location minus its start.
Useful for debugging or when call tracing is implemented.
*/
.size _start, . - _start
