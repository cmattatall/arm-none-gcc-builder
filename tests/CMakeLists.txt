cmake_minimum_required(VERSION 3.21)
include(FetchContent)


FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        c4e3767e265808590986d5db6ca1b5532a7f3d13 # v2.13.4
)
FetchContent_MakeAvailable(Catch2)

enable_testing()
include(CTest)

add_executable(catch2-tests)
target_sources(catch2-tests
    PRIVATE
        catch2/main.cpp
        catch2/catch2-usage-example.cpp

)

set_target_properties(catch2-tests 
    PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}
)

target_link_libraries(catch2-tests PRIVATE Catch2)