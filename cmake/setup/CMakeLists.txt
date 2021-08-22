cmake_minimum_required(VERSION 3.20)

include(ExternalProject)
include(FetchContent)

if(NOT IS_DIRECTORY ${PROJECT_SOURCE_DIR}/extern)
    file(MAKE_DIRECTORY ${PROJECT_SOURCE_DIR}/extern)
endif(NOT IS_DIRECTORY ${PROJECT_SOURCE_DIR}/extern)

set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_BASE_DIR ${PROJECT_SOURCE_DIR}/extern)

include(${CMAKE_CURRENT_LIST_DIR}/test-framework.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/configure-cmsis.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/configure-svd.cmake)