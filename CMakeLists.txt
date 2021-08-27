cmake_minimum_required(VERSION 3.21)

project(portable-firmware
    VERSION 0.1.0
    LANGUAGES CXX C ASM
)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/fetch-content.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake)


add_subdirectory(application)

if(CMAKE_CROSSCOMPILING)
    
    add_subdirectory(target)

endif(CMAKE_CROSSCOMPILING)


get_all_targets(all_targets)
message("All targets: ${all_targets}")