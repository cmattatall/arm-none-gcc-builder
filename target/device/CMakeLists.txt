cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

# ADD THIS FIRST BECAUSE DEPENDING ON HOW TERRIBLY THE DEVICE VENDORS HAVE
# ARCHITECTED THEIR SOFTWARE, THERE MAY BE CIRCULAR DEPENDENCIES OTHERWISE
add_subdirectory(vendor-config)
add_subdirectory(cpu)
add_subdirectory(linker)
add_subdirectory(startup)
add_subdirectory(peripherals)

target_link_libraries(${PROJECT_NAME}-device-startup 
    PUBLIC 
        ${PROJECT_NAME}-device-cpu-core
        ${PROJECT_NAME}-device-cpu-flags
        ${PROJECT_NAME}-device-vendor-config
        ${PROJECT_NAME}-device-linker
)

target_link_libraries(${PROJECT_NAME}-device-peripherals 
    PUBLIC 
        ${PROJECT_NAME}-device-startup
)

# Driver interface should inherit this as PUBLIC
add_library(${PROJECT_NAME}-device-build-deps INTERFACE)
target_link_libraries(${PROJECT_NAME}-device-build-deps
    INTERFACE
        ${PROJECT_NAME}-device-cpu-flags
        ${PROJECT_NAME}-device-linker
)

# Driver interface should inherit this as PRIVATE
add_library(${PROJECT_NAME}-device-interface INTERFACE)
target_link_libraries(${PROJECT_NAME}-device-interface
    INTERFACE
        ${PROJECT_NAME}-device-peripherals
)

# NOTE: If you try to use get_target_property to store properties 
#       like COMPILE_DEFINITIONS for device in a variable and then
#       print them, it will not work and you will get var-NOT_FOUND.
#   
#       The reason for this is that resolution of transitive dependencies
#       occurs at GENERATION time, not at CONFIGURE time and so cmake does
#       not append the INTERFACE_<PROPERTY> from the link interface 
#       properties to <PROPERTY> of device until ALL targets have been
#       configured. 
#
#       To confirm that the target is still correctly inheriting the transitive
#       compile flags, the best way (other than generator expression madness)
#       is to look at compile_commands.json
#
#       References: 
#           https://cmake.org/pipermail/cmake/2015-December/062174.html
#           https://cmake.org/pipermail/cmake/2015-December/062163.html





