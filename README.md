# mortem-os
This is an OS development project that is being developed with the intention of learning more about OS development and low-level programming.
I was inspired by [this video](https://www.youtube.com/watch?v=FaILnmUYS_U) by jdh.
I am still figuring out long term goals, but would either like to eventually develop an application for the OS and/or be able to develop 
mortem-os under the OS itself.

I am using the https://wiki.osdev.org resource to create this OS.

## Requirements
* Build a cross-compiler, tutorial found [here](https://wiki.osdev.org/GCC_Cross-Compiler). Make sure that wherever you install the cross-compiler, 
it is in your shell's `PATH`. Double check that the executable is what the `Makefile` calls for.
* For the time being, you must also have [grub](https://www.gnu.org/software/grub/) installed. A custom bootloader is planned for the future.
* Use a Unix-like OS (GNU/Linux, MacOS) or if on Windows use `WSL` or `Cygwin`.
* You will need a virtualizer. A good choice is [qemu](https://www.qemu.org/).

These requirements will change once [Docker](https://www.docker.com/) is used and a reproducible build environment is made. 
This will come after the custom bootloader.

## Building
Assuming you have met the requirements, there are several `make` commands you can use:
* running `make` should create the build folder then compile the kernel binary and iso file.
* `make dirs`: creates the build directory
* `make kernel`: creates the kernel binary in the build folder
* `make isodir`: creates the directory required to build the iso image with `grub`
* `make iso`: builds the iso image
* `make run-iso`: runs the compiled iso with `qemu-system-i386`
* `make clean`: cleans build file
* `make dist`: puts all files in the directory into a tarball for distribution if needed
* `make todolist`: checks source files for `TODO` and `FIXME` comments and lists them

## Running
Use the `kernel.bin` or `mortem-os.iso` files generated using `make` with your virtualizer, virtualizing a 32-bit machine.

## License
* [GNU General Public License v3.0](https://github.com/TheGuyMatt/mortem-os/blob/master/LICENSE)
