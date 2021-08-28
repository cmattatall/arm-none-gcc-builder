cmake_minimum_required(VERSION 3.21)

# TODO: We should be using a custom target + configure_file or something
#       to generate the stubs header from driver-interface.h and link against 
#       the stubbed definitions
#
#       But for now, we'll just hardcode the file.
#       file(COPY)

add_library(${PROJECT_NAME}-driver-interface-stubs)

target_include_directories(${PROJECT_NAME}-driver-interface-stubs
    PUBLIC 
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
)

target_sources(${PROJECT_NAME}-driver-interface-stubs
    PRIVATE
        src/driver-interface-stubs.c
)