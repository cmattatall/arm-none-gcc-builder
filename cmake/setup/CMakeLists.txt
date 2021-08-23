cmake_minimum_required(VERSION 3.20)

include(ExternalProject)
include(FetchContent)

set(FETCH_CONTENT_DIR ${PROJECT_BINARY_DIR}/extern)

if(NOT IS_DIRECTORY ${FETCH_CONTENT_DIR})
    file(MAKE_DIRECTORY ${FETCH_CONTENT_DIR})
endif(NOT IS_DIRECTORY ${FETCH_CONTENT_DIR})

set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_BASE_DIR ${FETCH_CONTENT_DIR})


if(CMAKE_CROSSCOMPILING)
    include(${CMAKE_CURRENT_LIST_DIR}/configure-cmsis.cmake)
    #include(${CMAKE_CURRENT_LIST_DIR}/configure-svd.cmake)
else()
    include(${CMAKE_CURRENT_LIST_DIR}/test-framework.cmake)
endif(CMAKE_CROSSCOMPILING)

