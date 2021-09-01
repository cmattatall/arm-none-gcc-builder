cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

add_library(${PROJECT_NAME}-driver-interface)

target_include_directories(${PROJECT_NAME}-driver-interface
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include/

    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
)

target_sources(${PROJECT_NAME}-driver-interface 
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/DI_uart.c
)


target_link_libraries(${PROJECT_NAME}-driver-interface
    PUBLIC
        ${PROJECT_NAME}-device-select

    PRIVATE
        ${PROJECT_NAME}-device-startup
        ${PROJECT_NAME}-device-peripherals
)