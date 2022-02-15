<!-- 
SPDX-FileCopyrightText: 2022 Matthew Nickson <mnickson@sidingsmedia.com>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# USB-Oscilloscope

Simple USB Oscilloscope using ATTiny85

## Building

To build this project, you must have downloaded the AVR toolchain. You
can get the toolchain in a number of ways. See
https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers
for toolchain downloads. The toolchain should also be added to path.

### Requirements

| Name | Version | Website |
|---|---|---|
| CMake | >= 3.23.0 | https://www.cmake.org |
| AVR Toolchain | >= 3.6.2 | https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers |

### CMake Parameters

Here are some important parameters than can be configured when running
CMake.

| Parameter | Value | Description |
|---|---|---|
| CMAKE_BUILD_TYPE | One of `Debug` or `Release` (default `Debug`) | Sets the build type for CMake|
| F_CPU | Integer (default `16000000UL`| Clock speed in MHz |
| MCU | String (default `attiny85`) | The MCU being used. |
| PROG_TYPE| String (default `usbtiny`)| ISP Programmer used by AVRDUDE. See `avrdude -c ?` for list of valid values |
| E_FUSE | Integer (default `0xFF`) | Value for extra fuse |
| H_FUSE | Integer (default `0xD9`) | Value for high fuse |
| L_FUSE | Integer (default `0xDF`) | Value for low fuse |
| LOCK_BIT | Integer (default `0xFF`) | Value for lock bit |
| BAUD | Integer (default `9600`) | Baud rate for programmer |

To set an option add `-D\<option>=\<value>` to the CMake command. E.g To
set the MCU use `-DMCU=attiny45`.

### Compiling

To compile you should run the following. Note: This assumes that you are
using the `Unix Makefiles` generator with CMake. If you are using
another generator like Ninja your commands may be diffrent.

```
mkdir build
cd build
cmake ..
make
```

To upload the compiled firmware to the board, ensure that your
programmer is correctly connected and then run:
```
make upload
```

To set the board fuses you should run:
```
make fuse
```

### Source lists
A list of all files that the compiler will compile is contained in
`cmake/sourcelist.cmake`. If a new file is added or an old one deleted,
this list must be updated.

## Licence
This project uses the [REUSE](https://reuse.software) standard in order
to communicate the correct licence for the file. For those unfamiliar
with the standard the licence for each file can be found in one of three
places. The licence will either be in a comment block at the top of the
file, in a `.license` file with the same name as the file, or in the
dep5 file located in the `.reuse` directory.
