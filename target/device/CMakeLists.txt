cmake_minimum_required(VERSION 3.21)

add_library(target-cpu)
target_link_libraries(target-cpu PUBLIC ARMCM3)