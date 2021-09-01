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



#[[
if(CMAKE_CROSSCOMPILING)

    set(LINKER_SCRIPT "STM32F411VETx_FLASH.ld")
    set(LINKER_SCRIPT_DIR ${PROJECT_SOURCE_DIR})

    # THIS WORKS
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-L,${LINKER_SCRIPT_DIR},-T,${LINKER_SCRIPT}")


    # NONE OF THESE WORK
    
    # 1.
    # target_link_options(${PROJECT_NAME} PRIVATE "-L ${LINKER_SCRIPT_DIR} -T ${LINKER_SCRIPT}")
    
    # 2.
    # set_target_properties(${PROJECT_NAME} PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT})
    
    # 3.
    # set_target_properties(${PROJECT_NAME} PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT_DIR}/${LINKER_SCRIPT})

    # 4.
    # add_link_options("-L ${LINKER_SCRIPT_DIR} -T ${LINKER_SCRIPT}")

    # 5.
    # add_compile_options("-Wl,-L,${LINKER_SCRIPT_DIR},-T,${LINKER_SCRIPT}")


endif(CMAKE_CROSSCOMPILING)

#]]




target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include/

    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
)



print_section_sizes(${PROJECT_NAME})
create_hex_output(${PROJECT_NAME})
create_bin_output(${PROJECT_NAME})
create_lss_output(${PROJECT_NAME})

