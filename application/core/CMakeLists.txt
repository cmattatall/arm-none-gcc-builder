cmake_minimum_required(VERSION 3.21)

add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME} 
    PRIVATE
        src/main.c
)


target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src/include/

    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include/
)