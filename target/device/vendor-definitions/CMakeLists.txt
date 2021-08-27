cmake_minimum_required(VERSION 3.21)

# Frequently, device vendors will provide a bunch of device header files
# with required preprocessor definitions to select one. This interface
# target is specificially to allow flexibility in configuring these definitions

add_library(${PROJECT_NAME}-device-vendor-definitions INTERFACE)
target_compile_definitions(${PROJECT_NAME}-device-vendor-definitions
    INTERFACE 
        STM32F411xE
        STM32
)