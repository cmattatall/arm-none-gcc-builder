cmake_minimum_required(VERSION 3.21)

# NOTES ON CREATING A VERSION HEADER (for future reference)
# https://cmake.org/pipermail/cmake/2010-July/038015.html

project(project
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


if(${CMAKE_VERSION} VERSION_GREATER "3.21.0")
    set(DOT_EXECUTABLE dot)
    find_program(DOT_EXE_PATH "${DOT_EXECUTABLE}${CMAKE_EXECUTABLE_SUFFIX}")
    if(${DOT_EXE_PATH} STREQUAL DOT_EXE_PATH-NOTFOUND)
        message(WARNING "Cannot create graphviz visualization of software architecture because executable: ${DOT_EXECUTABLE} not found")
    else()
        set(GRAPHVIZ_IMAGE_TARGET graphviz)
        if(NOT TARGET ${GRAPHVIZ_IMAGE_TARGET})
            add_custom_target(${GRAPHVIZ_IMAGE_TARGET} ALL
                COMMAND ${CMAKE_COMMAND} "--graphviz=graph.dot" .
                COMMAND ${DOT_EXECUTABLE} -Tpng graph.dot -o ${PROJECT_NAME}_software_arch.png
                WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
            )
        endif(NOT TARGET ${GRAPHVIZ_IMAGE_TARGET})
    endif(${DOT_EXE_PATH} STREQUAL DOT_EXE_PATH-NOTFOUND)
else()
    message(WARNING "Cannot create graphviz visualization of software architecture. Not supported in cmake version : ${CMAKE_VERSION}")
endif()

