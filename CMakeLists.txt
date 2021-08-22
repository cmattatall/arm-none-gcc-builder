cmake_minimum_required(VERSION 3.20)
include(ExternalProject)
include(FetchContent)

find_package(Git REQUIRED)
include(cmake/utils/git-utils.cmake)

project(arm-none-gcc-builder)

add_subdirectory(cmake/setup)



