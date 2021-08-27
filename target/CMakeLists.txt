cmake_minimum_required(VERSION 3.21)
add_subdirectory(device)
add_subdirectory(driver-interface)

if(TARGET ${PROJECT_NAME}-driver-interface)
    
    target_link_libraries(${PROJECT_NAME}-driver-interface 
        PRIVATE
            ${PROJECT_NAME}-device
    )

else()
    message(FATAL_ERROR "${PROJECT_NAME}-driver-interface cannot be linked against because it is not a target")
endif(TARGET ${PROJECT_NAME}-driver-interface)
