cmake_minimum_required(VERSION 3.20)
include(ExternalProject)
include(FetchContent)

find_package(Git REQUIRED)

FetchContent_Declare(
  cmsis
  GIT_REPOSITORY "git@github.com:ARM-software/CMSIS_5.git"
  GIT_TAG        13b9f72f212688d2306d0d085d87cbb4bf9e5d3f # release v5
  GIT_BRANCH     master
)

FetchContent_MakeAvailable(cmsis)