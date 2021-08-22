cmake_minimum_required(VERSION 3.20)
include(ExternalProject)
include(FetchContent)

find_package(Git REQUIRED)

project(arm-none-gcc-builder)

include(cmake/utils/git-utils.cmake)

if(NOT IS_DIRECTORY extern)
    file(MAKE_DIRECTORY extern)
endif(NOT IS_DIRECTORY extern)


git_clone(
    PROJECT_NAME    CMSIS
    GIT_URL         "git@github.com:ARM-software/CMSIS_5.git"
    GIT_BRANCH      master
    DIRECTORY       ${CMAKE_CURRENT_SOURCE_DIR}/extern
)


include(cmake/setup/test-framework.cmake)
include(cmake/setup/configure-cmsis.cmake)
include(cmake/setup/configure-svd.cmake)



