cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

# Frequently, device vendors will provide a bunch of device header files
# with required preprocessor definitions to select one. This interface
# target is specificially to allow flexibility in configuring these definitions
#
# 
# Sometimes, they also require a specific build-time configuration header file
# eg: stm32f4xx_hal_conf.h

add_library(${PROJECT_NAME}-device-vendor-config INTERFACE)
target_compile_definitions(${PROJECT_NAME}-device-vendor-config
    INTERFACE 
        STM32F411xE
)

target_include_directories(${PROJECT_NAME}-device-vendor-config
    INTERFACE 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)