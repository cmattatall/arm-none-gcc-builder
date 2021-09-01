cmake_minimum_required(VERSION 3.21)

add_library(${PROJECT_NAME}-middleware)
target_include_directories(${PROJECT_NAME}-middleware
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include/
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include/>
)

target_sources(${PROJECT_NAME}-middleware 
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/middleware.cpp
)


if(CMAKE_CROSSCOMPILING)

    # Application should only be able to call middleware APIs
    # not driver interface APIs so we make the link interface
    # private
    target_link_libraries(${PROJECT_NAME}-middleware
        PRIVATE
            ${PROJECT_NAME}-driver-interface
    )

    # We need to signal to the preprocessor which header to include and this 
    # is one of the simplest ways to do it
    target_compile_definitions(${PROJECT_NAME}-middleware PRIVATE CROSS_COMPILING)

else()
    target_link_libraries(${PROJECT_NAME}-middleware PRIVATE ${PROJECT_NAME}-driver-interface-stubs)
endif(CMAKE_CROSSCOMPILING)
