cmake_minimum_required(VERSION 3.21)

add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME} 
    PRIVATE
        src/main.cpp
)

set_target_properties(${PROJECT_NAME} 
    PROPERTIES 
        RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
)

target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include/

    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
)


if(CMAKE_CROSSCOMPILING)

    print_section_sizes(${PROJECT_NAME})
    create_hex_output(${PROJECT_NAME})
    create_bin_output(${PROJECT_NAME})
    create_lss_output(${PROJECT_NAME})

endif(CMAKE_CROSSCOMPILING)
