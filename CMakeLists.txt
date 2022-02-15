# SPDX-FileCopyrightText: 2022 Matthew Nickson <mnickson@sidingsmedia.com>
# SPDX-License-Identifier: MIT
cmake_minimum_required(VERSION 3.23.0)

set (CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH};${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
endif()
message("-- Build type: ${CMAKE_BUILD_TYPE}")
include(avr-gcc)
project("USB Oscilloscope" VERSION 0.1.0)
enable_language(CXX)
enable_language(C)
set(PRODUCT_NAME usb_oscilloscope)


# AVR Config
# 16MHz crystal
set(F_CPU 16000000UL)
# Using ATTiny85
set(MCU attiny85)

# Pass mmcu to linker
set(CMAKE_EXE_LINKER_FLAGS -mmcu=${MCU})

# Load files
include_directories(./include ./src)

# Language settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED True)

include(CTest)
enable_testing()

compile_avr(${PRODUCT_NAME} ${MCU})

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
