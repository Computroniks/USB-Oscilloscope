# SPDX-FileCopyrightText: 2022 Matthew Nickson <mnickson@sidingsmedia.com>
# SPDX-License-Identifier: MIT
include(sourcelist)
if(UNIX)
    set(OS_EXTENSION "")
elseif(WIN32)
    set(OS_EXTENSION ".exe")
endif()

find_path(TOOLCHAIN_PATH avr-gcc${OS_EXTENSION})

if(NOT TOOLCHAIN_PATH)
    message(FATAL_ERROR "AVR toolchain not found")
endif()

message("-- Toolchain path: ${TOOLCHAIN_PATH}")

# AVR compiller config
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)

set(CMAKE_C_COMPILER "${TOOLCHAIN_PATH}/avr-gcc${OS_EXTENSION}")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PATH}/avr-g++${OS_EXTENSION}")
set(CMAKE_AR "${TOOLCHAIN_PATH}/avr-ar${OS_EXTENSION}")
set(CMAKE_LINKER "${TOOLCHAIN_PATH}/avr-ld${OS_EXTENSION}")
set(CMAKE_NM "${TOOLCHAIN_PATH}/avr-nm${OS_EXTENSION}")
set(CMAKE_OBJCOPY "${TOOLCHAIN_PATH}/avr-objcopy${OS_EXTENSION}")
set(CMAKE_OBJDUMP "${TOOLCHAIN_PATH}/avr-objdump${OS_EXTENSION}")
set(CMAKE_STRIP "${TOOLCHAIN_PATH}/avr-strip${OS_EXTENSION}")
set(CMAKE_RANLIB "${TOOLCHAIN_PATH}/avr-ranlib${OS_EXTENSION}")
set(AVR_SIZE "${TOOLCHAIN_PATH}/avr-size${OS_EXTENSION}")

# AVRDUDE
find_program(AVRDUDE avrdude)
if(NOT AVRDUDE)
    message(SEND_ERROR "AVRDUDE could not be found")
else()
    message("-- AVRDUDE Path: ${AVRDUDE}")
endif()
# UART baud rate
set(BAUD 9600)
# Programmer
set(PROG_TYPE usbtiny)
# Fuses
set(E_FUSE 0xFF)
set(H_FUSE 0xD9)
set(L_FUSE 0xDF)
set(LOCK_BIT 0xFF)


# Executable
macro(compile_avr target_name mcu)
    set(elf_file ${target_name}-${mcu}.elf)
    set(map_file ${target_name}-${mcu}.map)
    set(hex_file ${target_name}-${mcu}.hex)
    set(lst_file ${target_name}-${mcu}.lst)
    set(eep_file ${target_name}-${mcu}.eep)

    # Compiler options
    add_compile_options(
        -mmcu=${MCU} 
        -std=c++11
        -Os 
        -Wall 
        -Wno-main
        -Wundef
        -pedantic
        -Werror
        -Wfatal-errors
        -Wl,--relax,--gc-sections
        -g
        -gdwarf-2
        -funsigned-char 
        -funsigned-bitfields
        -fpack-struct
        -fshort-enums
        -ffunction-sections
        -fdata-sections
        -fno-split-wide-types
        -fno-tree-scev-cprop
        -DF_CPU=${F_CPU}
        -DBAUD=${BAUD}
    )

    # Generate .elf
    add_executable(${elf_file} ${SRC_LIST})
    # Generate .lst
    add_custom_command(
        OUTPUT ${lst_file}

        COMMAND
            ${CMAKE_OBJDUMP} -h -S ${elf_file} > ${lst_file}

        DEPENDS ${elf_file}
    )
    # Generate .hex
    add_custom_command(
        OUTPUT ${hex_file}

        COMMAND
            ${CMAKE_OBJCOPY} -R .eeprom -O ihex ${elf_file} ${hex_file}

        DEPENDS ${elf_file}
    )
    # Generate .eep
    add_custom_command(
        OUTPUT ${eep_file}

        COMMAND
            ${CMAKE_OBJCOPY} -j .eeprom  --set-section-flags=.eeprom="alloc,load"  --change-section-lma .eeprom=0 -O ihex ${elf_file} ${eep_file}

        DEPENDS ${elf_file} 
    )
    add_custom_target(
        ${target_name}
        ALL
        DEPENDS ${hex_file} ${lst_file} 
    )
    # Upload
    add_custom_target(
        upload
        ${AVRDUDE}  -c ${PROG_TYPE} -p ${mcu} -U flash:w:${hex_file} 
        DEPENDS ${hex_file}
    )
    # Upload EEPROM
    add_custom_target(
        upload_eeprom
        ${AVRDUDE} -c ${PROG_TYPE} -p ${mcu}  -U eeprom:w:${eep_file} 
        DEPENDS ${eep_file}
    )
    # Set fuses
    add_custom_target(fuses
        ${AVRDUDE} -c ${PROG_TYPE} -p ${mcu}  -U lfuse:w:${L_FUSE}:m -U hfuse:w:${H_FUSE}:m -U efuse:w:${E_FUSE}:m -U lock:w:${LOCK_BIT}:m
    )
endmacro()
