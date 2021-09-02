cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_FILE} can only be used as a subdirectory when cross compiling")
endif(NOT CMAKE_CROSSCOMPILING)

set(LINKER_SCRIPT "STM32F411VETx_FLASH.ld")
set(LINKER_SCRIPT_ABSOLUTE "${CMAKE_CURRENT_SOURCE_DIR}/${LINKER_SCRIPT}")

add_library(${PROJECT_NAME}-linker-script INTERFACE)
target_link_libraries(${PROJECT_NAME}-linker-script 
    INTERFACE
        -T"${LINKER_SCRIPT_ABSOLUTE}"
)
