cmake_minimum_required(VERSION 3.21)

add_library(${PROJECT_NAME}-device-cpu INTERFACE)

target_compile_options(${PROJECT_NAME}-device-cpu 
    INTERFACE
        -mthumb
        -mcpu=cortex-m4
        -mfloat-abi=softfp
        -mfpu=fpv4-sp-d16
)