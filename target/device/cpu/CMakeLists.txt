cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

add_subdirectory(core)
add_subdirectory(flags)


add_library(${PROJECT_NAME}-device-cpu INTERFACE)

target_link_libraries(${PROJECT_NAME}-device-cpu 
    INTERFACE
        ${PROJECT_NAME}-device-cpu-core
        ${PROJECT_NAME}-device-cpu-flags
)
