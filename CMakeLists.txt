cmake_minimum_required(VERSION 3.21)

# NOTES ON CREATING A VERSION HEADER (for future reference)
# https://cmake.org/pipermail/cmake/2010-July/038015.html

project(example_firmware
    VERSION 0.1.0
    LANGUAGES CXX C ASM
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/fetch-content.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake)




add_subdirectory(application)

if(CMAKE_CROSSCOMPILING)
    
    add_subdirectory(target)

endif(CMAKE_CROSSCOMPILING)


get_all_targets(all_targets)
message("listing all targets:")
foreach(target ${all_targets})
    message("${target}")
endforeach(target ${all_targets})



if(NOT UTIL_SEARCH_COMMAND)

    if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)
        set(UTIL_SEARCH_COMMAND which)

    # Windows users are going to have to update this approprately and submit PR
    elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Windows) 
        set(UTIL_SEARCH_COMMAND which)

    else()
        message(FATAL_ERROR 
            "Unknown value for UTIL_SEARCH_COMMAND (${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LINE}. \
            Reason: ${CMAKE_HOST_SYSTEM_NAME} not supported. \
            Please add your own switch for your search utility to ${CMAKE_CURRENT_LIST_FILE} (near ${CMAKE_CURRENT_LINE) \
            and submit a pull request."
        )
    endif()

endif(NOT UTIL_SEARCH_COMMAND)


set(DOT_EXECUTABLE dot)
execute_process(
    COMMAND ${UTIL_SEARCH_COMMAND} ${DOT_EXECUTABLE}
    OUTPUT_VARIABLE DOT_EXECUTABLE_PATH
    RESULT_VARIABLE DOT_EXECUTABLE_NOT_FOUND
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if(NOT DOT_EXECUTABLE_NOT_FOUND)
    if(NOT TARGET graphviz)
        add_custom_target(graphviz ALL
            COMMAND ${CMAKE_COMMAND} "--graphviz=graph.dot" .
            COMMAND ${DOT_EXECUTABLE} -Tpng graph.dot -o ${PROJECT_NAME}_software_arch.png
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        )
    endif(NOT TARGET graphviz)
else()
    message(WARNING "Cannot create graphviz visualization of software architecture because ${DOT_EXECUTABLE} not found")
endif(NOT DOT_EXECUTABLE_NOT_FOUND)

