/*
linker.ld: linker file for mortem-os

Author: Matthew Hieb
Date Created: 2021-06-08

Created using the bare bones tutorial on wiki.osdev.org
https://wiki.osdev.org/Bare_Bones
*/

/* bootloader looks here for entry point to start execution */
ENTRY(_start)

/* Tell where the various sections of the object files will be put in
   the final kernel image */
SECTIONS
{
  /* Begin putting sections at 1 MiB, a conventional place for kernels
     to be loaded at by the bootloader. */
  . = 1M;

  /* First put the multiboot header so bootloader can recognize the
     file format. Next put the .text section. */
  .text BLOCK(4K) : ALIGN(4K)
  {
    *(.multiboot)
    *(.text)
  }

  /* read-only data */
  .rodata BLOCK(4K) : ALIGN(4K)
  {
    *(.rodata)
  }

  /* read-write data (initialized) */
  .data BLOCK(4K) : ALIGN(4K)
  {
    *(.data)
  }

  /* read-write data (uninitialized) and stack */
  .bss BLOCK(4K) : ALIGN(4K)
  {
    *(COMMON)
    *(.bss)
  }

  /* Compiler may produce other sections, by default it will put them in
     a segment with the same name. Add stuff here as needed */
}
