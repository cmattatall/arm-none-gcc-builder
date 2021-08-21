cmake_minimum_required(VERSION 3.20)
include(ExternalProject)
include(FetchContent)

project(arm-none-gcc-builder)


find_package(Git REQUIRED)

#git@github.com:FreeRTOS/FreeRTOS.git

set(CMSIS_5_REPO_URL "git@github.com:ARM-software/CMSIS_5.git") # This can be replaced with a stable mirror later

FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        703bd9caab50b139428cea1aaff9974ebee5742e # release-1.10.0
)

FetchContent_Declare(
  catch2
  URL https://github.com/catchorg/Catch2/archive/refs/tags/v2.13.7.tar.gz
)


# Check if population has already been performed
FetchContent_GetProperties(googletest)
string(TOLOWER "googletest" lcName)
if(NOT ${lcName}_POPULATED)
  # Fetch the content using previously declared details
  FetchContent_Populate(googletest)

  # Set custom variables, policies, etc.
  # ...

  # Bring the populated content into the build
  add_subdirectory(${${lcName}_SOURCE_DIR} ${${lcName}_BINARY_DIR})
endif()


# Check if population has already been performed
FetchContent_GetProperties(catch2)
string(TOLOWER "catch2" lcName)
if(NOT ${lcName}_POPULATED)
  # Fetch the content using previously declared details
  FetchContent_Populate(catch2)

  # Set custom variables, policies, etc.
  # ...

  # Bring the populated content into the build
  add_subdirectory(${${lcName}_SOURCE_DIR} ${${lcName}_BINARY_DIR})
endif()

#FetchContent_MakeAvailable(CMSIS_5)



