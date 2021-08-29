cmake_minimum_required(VERSION 3.21)
find_package(Git REQUIRED)
include(FetchContent)

set(FETCHCONTENT_QUIET OFF)
set(FETCHCONTENT_BASE_DIR ${PROJECT_SOURCE_DIR}/extern)

if(CMAKE_CROSSCOMPILING)

  include(${CMAKE_CURRENT_LIST_DIR}/fetch-content/fetch-cmsis.cmake)
  include(${CMAKE_CURRENT_LIST_DIR}/fetch-content/fetch-svd.cmake)
  include(${CMAKE_CURRENT_LIST_DIR}/fetch-content/fetch-stm32cube.cmake)

else()

  include(${CMAKE_CURRENT_LIST_DIR}/fetch-content/fetch-test-frameworks.cmake)

endif(CMAKE_CROSSCOMPILING)
