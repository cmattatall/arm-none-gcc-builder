cmake_minimum_required(VERSION 3.21)

if(CMAKE_CROSSCOMPILING)

    add_subdirectory(linker)
    add_subdirectory(device)
    add_subdirectory(device-select)
    add_subdirectory(driver-interface)




else()
    message(STATUS "Not cross compiling so ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt will not be processed.")
endif(CMAKE_CROSSCOMPILING)
