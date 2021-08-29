cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
include(FetchContent)
FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        c4e3767e265808590986d5db6ca1b5532a7f3d13 # v2.13.4
)
FetchContent_MakeAvailable(Catch2)

enable_testing()
include(CTest)

add_executable(unit-tests)
target_sources(unit-tests
    PRIVATE
        catch2/main.cpp
        catch2/catch2-usage-example.cpp
)

set_target_properties(unit-tests 
    PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
)

target_link_libraries(unit-tests 
    PRIVATE 
        Catch2
        ${PROJECT_NAME}-middleware
)

add_custom_target(run-unit-tests ALL
    ./unit-tests
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
)

else()
    message(STATUS "Cross compiling so ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt will not be processed.")
endif(NOT CMAKE_CROSSCOMPILING)
