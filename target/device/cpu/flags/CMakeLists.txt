cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

add_library(${PROJECT_NAME}-device-cpu-flags INTERFACE)
target_compile_options(${PROJECT_NAME}-device-cpu-flags
    INTERFACE
        -mthumb
        -mcpu=cortex-m4
        -mfloat-abi=softfp
        -mfpu=fpv4-sp-d16
)