cmake_minimum_required(VERSION 3.21)

add_subdirectory(core)

if(NOT CMAKE_CROSSCOMPILING)
    add_subdirectory(driver-interface-stubs)
endif(NOT CMAKE_CROSSCOMPILING)

add_subdirectory(middleware)

target_link_libraries(${PROJECT_NAME} 
    PRIVATE 
        ${PROJECT_NAME}-middleware
)

