cmake_minimum_required(VERSION 3.20)
find_package(Git REQUIRED)

if(IS_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake_git_clone)
    message("cmake_git_clone already exists")
else()
    execute_process(
        COMMAND git clone git@github.com:cmattatall/cmake_git_clone.git
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        RESULTS_VARIABLE GIT_UTILS_RESULT
        OUTPUT_VARIABLE GIT_UTILS_OUTPUT
        ECHO_OUTPUT_VARIABLE    
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif(IS_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/cmake_git_clone)

include(${CMAKE_CURRENT_BINARY_DIR}/cmake_git_clone/cmake/GitUtils.cmake)
