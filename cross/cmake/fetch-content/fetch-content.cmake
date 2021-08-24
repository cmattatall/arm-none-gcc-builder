cmake_minimum_required(VERSION 3.21)
find_package(Git REQUIRED)
include(FetchContent)
set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_BASE_DIR ${PROJECT_BINARY_DIR}/fetched_content)

include(${CMAKE_CURRENT_LIST_DIR}/content/fetch-cmsis.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/content/fetch-svd.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/content/fetch-stm32cube.cmake)


