cmake_minimum_required(VERSION 3.21)
################################################################################
# YOU MAY WISH TO USE A CUSTOM LINKER SCRIPT, ADD IT IN THIS FILE HERE
################################################################################
#
# Also, note that using a custom linker script is only supported
# for ninja and makefile generators. If you are a Texas Instruments corporate 
# shill and they do not yet support fixes for your section placements, vector 
# table, etc... via their cacophony of cludgy eclipse plugins (perhaps due to 
# silicon erratta in newer foundry batches of your chip), then you're out
# of luck and should probably just spend some time learning more about how a
# binary image is actually created so you don't have to use CCS in the first
# place. 
#
# Additional reading: https://cmake.org/cmake/help/latest/prop_tgt/INTERFACE_LINK_DEPENDS.html

add_library(${PROJECT_NAME}-device-linker INTERFACE)

# There are a couple ways to do this but cmake is unclear on which is the 
# intended way. - August 2021
# set_target_properties(device-linker PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT})

# set_property(TARGET mylib PROPERTY INTERFACE_LINK_DEPENDS
#        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/mylinkscript>
#        $<INSTALL_INTERFACE:mylinkscript>  # <prefix>/mylinkscript
#    )

# 

