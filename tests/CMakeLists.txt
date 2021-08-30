cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
include(FetchContent)
FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        c4e3767e265808590986d5db6ca1b5532a7f3d13 # v2.13.4
)
FetchContent_MakeAvailable(Catch2)


set(AUTOMATED_TEST_TARGETS "")

macro(add_automated_test target)
    add_executable(${target})
    set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})
    add_test(
        NAME run-${target}
        COMMAND ./${target}
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    )
    list(APPEND AUTOMATED_TEST_TARGETS ${target})
endmacro(add_automated_test target)

add_automated_test(catch2-tests)
target_sources(catch2-tests
    PRIVATE
        catch2/main.cpp
        catch2/middleware-init.cpp
        catch2/catch2-usage-example.cpp
)
target_link_libraries(catch2-tests 
    PRIVATE 
        Catch2
        ${PROJECT_NAME}-middleware
)

target_include_directories(catch2-tests 
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/catch2/include
        ${CMAKE_CURRENT_SOURCE_DIR}/catch2/include/mocks
)

add_custom_target(run-tests ALL COMMAND ${CMAKE_CTEST_COMMAND} --verbose DEPENDS ${AUTOMATED_TEST_TARGETS})

else()
    message(STATUS "Cross compiling so ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt will not be processed.")
endif(NOT CMAKE_CROSSCOMPILING)
