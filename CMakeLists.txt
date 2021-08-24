# Commented out until some higher-level project structre stuff is figured out
#[[
cmake_minimum_required(VERSION 3.20)
include(ExternalProject)
include(FetchContent)

option(BUILD_TESTS "Option to build the tests" OFF)
option(BUILD_CROSS "Option to cross-compile" OFF)

find_package(Git REQUIRED)
include(cmake/utils/git-utils.cmake)

project(arm-none-gcc-builder)

add_subdirectory(cmake/setup)


#]]