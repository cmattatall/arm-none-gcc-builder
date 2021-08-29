cmake_minimum_required(VERSION 3.21)

if(CMAKE_CROSSCOMPILING)
    
    add_subdirectory(device)
    add_subdirectory(driver-interface)


    target_link_libraries(${PROJECT_NAME}-driver-interface 
        PUBLIC
            ${PROJECT_NAME}-device-build-deps
        PRIVATE
            ${PROJECT_NAME}-device-interface
    )

    add_library(${PROJECT_NAME}-driver-build-deps INTERFACE)
    target_link_libraries(${PROJECT_NAME}-driver-build-deps
        INTERFACE
            ${PROJECT_NAME}-device-build-deps
    )

else()
    message(STATUS "Not cross compiling so ${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt will not be processed.")
endif(CMAKE_CROSSCOMPILING)
