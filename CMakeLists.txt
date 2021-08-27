cmake_minimum_required(VERSION 3.21)

# NOTES ON CREATING A VERSION HEADER (for future reference)
# https://cmake.org/pipermail/cmake/2010-July/038015.html

project(portable-firmware
    VERSION 0.1.0
    LANGUAGES CXX C ASM
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/fetch-content.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake)


add_subdirectory(application)

if(CMAKE_CROSSCOMPILING)
    
    add_subdirectory(target)

endif(CMAKE_CROSSCOMPILING)


get_all_targets(all_targets)
message("listing all targets:")
foreach(target ${all_targets})
    message("${target}")
endforeach(target ${all_targets})