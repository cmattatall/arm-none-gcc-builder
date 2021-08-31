cmake_minimum_required(VERSION 3.21)
if(NOT CMAKE_CROSSCOMPILING)
    include(FetchContent)
    set(FETCHCONTENT_QUIET OFF)
    FetchContent_Declare(
        Catch2
        GIT_REPOSITORY https://github.com/catchorg/Catch2.git
        GIT_TAG        c4e3767e265808590986d5db6ca1b5532a7f3d13 # v2.13.4
    )
    FetchContent_MakeAvailable(Catch2)

    add_unit_test(catch2-tests)

    file(GLOB catch2_sources "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
    target_sources(catch2-tests PRIVATE ${catch2_sources})
    target_link_libraries(catch2-tests 
        PRIVATE 
            Catch2
            ${PROJECT_NAME}-middleware
    )
    target_include_directories(catch2-tests 
        PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/include
            ${CMAKE_CURRENT_SOURCE_DIR}/include/mocks
    )

else()
    message(STATUS "Cross compiling so ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt will not be processed.")
endif(NOT CMAKE_CROSSCOMPILING)
