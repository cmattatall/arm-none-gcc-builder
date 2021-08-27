cmake_minimum_required(VERSION 3.21)

project(portable-firmware
    VERSION 0.1.0
    LANGUAGES CXX C ASM
)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/cmake/fetch-content)

add_subdirectory(application)

if(CMAKE_CROSSCOMPILING)
    
    add_subdirectory(target)

endif(CMAKE_CROSSCOMPILING)
