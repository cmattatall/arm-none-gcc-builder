cmake_minimum_required(VERSION 3.21)

add_library(${PROJECT_NAME}-device-startup INTERFACE)

target_sources(${PROJECT_NAME}-device-startup
    INTERFACE
        ${FETCHCONTENT_BASE_DIR}/stm32f4-src/Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f411xe.s
        ${FETCHCONTENT_BASE_DIR}/stm32f4-src/Drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c
)

target_include_directories(${PROJECT_NAME}-device-startup 
    INTERFACE
        ${FETCHCONTENT_BASE_DIR}/stm32f4-src/Drivers/CMSIS/Device/ST/STM32F4xx/Include/
        ${FETCHCONTENT_BASE_DIR}/stm32f4-src/Drivers/CMSIS/Core/Include/
)

