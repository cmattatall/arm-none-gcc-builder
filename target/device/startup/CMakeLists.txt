cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

add_library(${PROJECT_NAME}-device-startup)

target_sources(${PROJECT_NAME}-device-startup
    PRIVATE
        src/startup_stm32f411xe.s
        src/system_stm32f4xx.c
)

target_include_directories(${PROJECT_NAME}-device-startup 
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src/include>
)


target_link_libraries(${PROJECT_NAME}-device-startup 
    PUBLIC 
        ${PROJECT_NAME}-device-cpu
    PRIVATE
        ${PROJECT_NAME}-device-vendor-config
)
