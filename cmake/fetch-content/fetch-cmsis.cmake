cmake_minimum_required(VERSION 3.21)

FetchContent_Declare(
    cmsis
    GIT_REPOSITORY "https://github.com/cmattatall/CMSIS_5.git"
)

# This is the other way to do it but 
# we don't need such fine-grained control right now
#
#[[
FetchContent_GetProperties(cmsis)
string(TOLOWER "cmsis" lcName)
if(NOT ${lcName}_POPULATED)
    message("Fetching external content for cmsis ... ")
    FetchContent_Populate(cmsis)
    add_subdirectory(${${lcName}_SOURCE_DIR} ${${lcName}_BINARY_DIR})
else()
    message("External content cmsis is already populated")
endif()
#]]


FetchContent_MakeAvailable(cmsis)
