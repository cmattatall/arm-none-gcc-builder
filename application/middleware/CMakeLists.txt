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
        ${CMAKE_CURRENT_SOURCE_DIR}/src/middleware.c
)


if(CMAKE_CROSSCOMPILING)

    # Application should only be able to call middleware APIs
    # not driver interface APIs so we make the link interface
    # private
    target_link_libraries(${PROJECT_NAME}-middleware
        PUBLIC
            ${PROJECT_NAME}-driver-interface
    )

endif(CMAKE_CROSSCOMPILING)
