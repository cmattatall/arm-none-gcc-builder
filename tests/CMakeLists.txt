cmake_minimum_required(VERSION 3.21)

# These are tests of the build system itself, not of the code being built
add_subdirectory(meta)

# These are catch2 unit tests
add_subdirectory(catch2)

get_all_tests(tests ${CMAKE_CURRENT_SOURCE_DIR})

message("listing tests for project: ${PROJECT_NAME} ...")
foreach(test ${tests})
    message("- ${test}")
endforeach(test ${tests})
message("")
