cmake_minimum_required(VERSION 3.21)
add_subdirectory(device)
add_subdirectory(driver-interface)


target_link_libraries(${PROJECT_NAME}-driver-interface 
    PUBLIC
        ${PROJECT_NAME}-device-build-deps
    PRIVATE
        ${PROJECT_NAME}-device-api
)