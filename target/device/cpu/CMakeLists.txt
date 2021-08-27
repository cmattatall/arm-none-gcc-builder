cmake_minimum_required(VERSION 3.21)

add_library(device-cpu)
target_link_libraries(device-cpu INTERFACE ARMCM3)

# NOTE: If you try to use get_target_property to store properties 
#       like COMPILE_DEFINITIONS for device-cpu in a variable and then
#       print them, it will not work and you will get var-NOT_FOUND.
#   
#       The reason for this is that resolution of transitive dependencies
#       occurs at GENERATION time, not at CONFIGURE time and so cmake does
#       not append the INTERFACE_<PROPERTY> from the link interface 
#       properties to <PROPERTY> of device-cpu until ALL targets have been
#       configured. 
#
#       To confirm that the target is still correctly inheriting the transitive
#       compile flags, the best way (other than generator expression madness)
#       is to look at compile_commands.json
#
#       References: 
#           https://cmake.org/pipermail/cmake/2015-December/062174.html
#           https://cmake.org/pipermail/cmake/2015-December/062163.html