cmake_minimum_required(VERSION 3.21)

set(TEST_OUTPUT_DIR ${PROJECT_BINARY_DIR}/tests)
if(NOT IS_DIRECTORY ${TEST_OUTPUT_DIR})
    file(MAKE_DIRECTORY ${TEST_OUTPUT_DIR})
endif(NOT IS_DIRECTORY ${TEST_OUTPUT_DIR})

function(add_unit_test target)
    add_executable(${target})
    set_target_properties(${target} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${TEST_OUTPUT_DIR})
    add_test(
        NAME ${target}
        COMMAND ./${target}
        WORKING_DIRECTORY ${TEST_OUTPUT_DIR}
    )
endfunction(add_unit_test target)


# These are catch2 unit tests
add_subdirectory(catch2)

get_all_tests(test_targets)
if(test_targets)
    message("")
    message(STATUS "Tests for project ${PROJECT_NAME}:")
    foreach(test ${test_targets})
        message(STATUS " > ${test}")
    endforeach(test ${test_targets})
    message("")
    add_custom_target(run-tests ALL COMMAND ${CMAKE_CTEST_COMMAND} --verbose DEPENDS ${test_targets})
else()
    message(STATUS "No automated post-build tests detected for project ${PROJECT_NAME}")
endif(test_targets)
