cmake_minimum_required(VERSION 3.21)


# NOTES ON CREATING A VERSION HEADER (for future reference)
# https://cmake.org/pipermail/cmake/2010-July/038015.html

project(project
    VERSION 0.1.0
    LANGUAGES CXX C ASM
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 99)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/utils.cmake)

message("")
message("")



if(PRODUCTION)

    message(STATUS "Building project: \"${PROJECT_NAME}\" for production.")

    set(CMAKE_BUILD_TYPE MinSizeRel)

    set(CMAKE_C_FLAGS_MINSIZEREL
        "\
        ${CMAKE_C_FLAGS_MINSIZEREL} \
        -ffunction-sections \
        -fdata-sections \
        -flto \
        -ffat-lto-objects \
        -fuse-linker-plugin \
        "
    )

    set(CMAKE_CXX_FLAGS_MINSIZEREL 
        "\         
        ${CMAKE_CXX_FLAGS_MINSIZEREL} \
        -ffunction-sections \
        -fdata-sections \
        -flto \
        -ffat-lto-objects \
        -fuse-linker-plugin \
        "
    )

else()
    if(NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE_DEFAULT Debug)
        message(WARNING "CMAKE_BUILD_TYPE not set so using ${CMAKE_BUILD_TYPE_DEFAULT} as default")
        set(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE_DEFAULT})
    endif()
endif()


add_subdirectory(application)
add_subdirectory(target)
add_subdirectory(tests)



get_all_targets(all_targets)
message("")
message("Targets for project: ${PROJECT_NAME}")
set(UTILITY_TARGETS "")
foreach(target ${all_targets})
    get_target_property(TYPE ${target} TYPE)
    
    if(TYPE STREQUAL UTILITY)
        list(APPEND UTILITY_TARGETS ${target})
    else()
        message("- ${target}")
    endif()
endforeach(target ${all_targets})
message("")
message("Utility targets for project: ${PROJECT_NAME}")
foreach(util_target ${UTILITY_TARGETS})
    message("- ${util_target}")
endforeach(util_target ${UTILITY_TARGETS})
message("")



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


