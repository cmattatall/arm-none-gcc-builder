cmake_minimum_required(VERSION 3.21)

add_library(${PROJECT_NAME}-driver-interface)

target_include_directories(${PROJECT_NAME}-driver-interface
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include/

    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include/
)

target_sources(${PROJECT_NAME}-driver-interface 
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/DI_uart.c
)



