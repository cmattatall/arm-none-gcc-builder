cmake_minimum_required(VERSION 3.20)

find_package(Git REQUIRED)
project(cross-build)

include(cmake/fetch-content/fetch-content.cmake)