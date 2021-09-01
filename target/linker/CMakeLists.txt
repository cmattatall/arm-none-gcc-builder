cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

# this seems to be the best guide on making the custom linker script work
# https://gitlab.kitware.com/cmake/cmake/-/issues/17997


#[[
add_library(${PROJECT_NAME}-linker-script INTERFACE)

set(${LINKER_SCRIPT_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
set(${LINKER_SCRIPT} STM32F411VETx_FLASH.ld)

target_link_libraries(${PROJECT_NAME}-linker-script
    INTERFACE
        ${LINKER_SCRIPT}
)

target_link_directories(${PROJECT_NAME}-linker-script
    INTERFACE
        ${LINKER_SCRIPT_DIR}
)

#]]
