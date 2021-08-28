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



set(DOT_EXECUTABLE dot)
find_program(DOT_EXE "${DOT_EXECUTABLE}")
if(NOT ${DOT_EXE}-NOTFOUND)
    set(GRAPHVIZ_IMAGE_TARGET graphviz)
    if(NOT TARGET ${GRAPHVIZ_IMAGE_TARGET})
        add_custom_target(${GRAPHVIZ_IMAGE_TARGET} ALL
            COMMAND ${CMAKE_COMMAND} "--graphviz=graph.dot" .
            COMMAND ${DOT_EXECUTABLE} -Tpng graph.dot -o ${PROJECT_NAME}_software_arch.png
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        )
    endif(NOT TARGET ${GRAPHVIZ_IMAGE_TARGET})
else()
    message(WARNING "Cannot create graphviz visualization of software architecture because ${DOT_EXECUTABLE} not found")
endif(NOT ${DOT_EXE}-NOTFOUND)

