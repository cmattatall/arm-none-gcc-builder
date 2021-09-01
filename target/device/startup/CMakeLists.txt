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


message(FATAL_ERROR "FIX ME IN THE CROSS BUILD BECAUSE I FOR SOME REASON GETTING THE PROPER LINKER SCRIPT TO RUN IS AN ABSOLUTE BASTARD")
# THIS DOESN'T SEEM TO WORK
set(LINKER_SCRIPT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(LINKER_SCRIPT "STM32F411VETx_FLASH.ld")
add_compile_options("-Wl,-L,${LINKER_SCRIPT_DIR},-T,${LINKER_SCRIPT}")