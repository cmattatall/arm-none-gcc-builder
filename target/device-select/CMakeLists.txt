cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

add_library(${PROJECT_NAME}-device-select INTERFACE)

target_compile_definitions(${PROJECT_NAME}-device-select
    INTERFACE
        STM32_CHIP
)


target_link_libraries(${PROJECT_NAME}-device-select
    INTERFACE
        ${PROJECT_NAME}-device-cpu
)