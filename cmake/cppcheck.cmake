cmake_minimum_required(VERSION 3.21)

function(add_cppcheck)
    
    if(PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)

        get_all_targets(target_list)
        foreach(target ${target_list})
            get_target_property(type ${target} TYPE)

            if(type STREQUAL STATIC_LIBRARY)
            elseif(type STREQUAL MODULE_LIBRARY)
            elseif(type STREQUAL SHARED_LIBRARY)
            elseif(type STREQUAL OBJECT_LIBRARY)
            elseif(type STREQUAL EXECUTABLE)
            else()
                # if the target doesn't have code associated with it, remove it from
                # the static analysis dependency list
                list(REMOVE_ITEM target_list ${target})
            endif()
        endforeach(target ${target_list})

        find_program(CPPCHECK_BIN NAMES cppcheck REQUIRED)
        if(CPPCHECK_BIN)
            execute_process(COMMAND ${CPPCHECK_BIN} --version
                OUTPUT_VARIABLE CPPCHECK_VERSION
                ERROR_QUIET
                OUTPUT_STRIP_TRAILING_WHITESPACE
            )
    
            set(CPPCHECK_THREADS_ARG "-j4" CACHE STRING "The number of threads to use")
            if(NOT CMAKE_EXPORT_COMPILE_COMMANDS)
                set(CMAKE_EXPORT_COMPILE_COMMANDS ON) # can't use cppcheck without compile commands
            endif(NOT CMAKE_EXPORT_COMPILE_COMMANDS)
            set(CPPCHECK_PROJECT_ARG "--project=${PROJECT_BINARY_DIR}/compile_commands.json")
            set(CPPCHECK_BUILD_DIR_ARG "--cppcheck-build-dir=${PROJECT_BINARY_DIR}/analysis/cppcheck" CACHE STRING "The build directory to use")

            # Don't show thise errors
            if(EXISTS "${CMAKE_SOURCE_DIR}/.cppcheck_suppressions")
                set(CPPCHECK_SUPPRESSIONS "--suppressions-list=${CMAKE_SOURCE_DIR}/.cppcheck_suppressions" CACHE STRING "The suppressions file to use")
            else()
                set(CPPCHECK_SUPPRESSIONS "" CACHE STRING "The suppressions file to use")
            endif()
        
            # Show these errors but don't fail the build
            # These are mainly going to be from the "warning" category that is enabled by default later
            if(EXISTS "${CMAKE_SOURCE_DIR}/.cppcheck_exitcode_suppressions")
                set(CPPCHECK_EXITCODE_SUPPRESSIONS "--exitcode-suppressions=${CMAKE_SOURCE_DIR}/.cppcheck_exitcode_suppressions" CACHE STRING "The exitcode suppressions file to use")
            else()
                set(CPPCHECK_EXITCODE_SUPPRESSIONS "" CACHE STRING "The exitcode suppressions file to use")
            endif()
        
            set(CPPCHECK_ERROR_EXITCODE_ARG "--error-exitcode=1" CACHE STRING "The exitcode to use if an error is found")
            set(CPPCHECK_CHECKS_ARGS "--enable=warning" CACHE STRING "Arguments for the checks to run")
            set(CPPCHECK_OTHER_ARGS "" CACHE STRING "Other arguments")
            set(CPPCHECK_EXCLUDES)
        
            ## set exclude files and folders
            foreach(ex ${CPPCHECK_EXCLUDES})
                list(APPEND CPPCHECK_EXCLUDES "-i${ex}")
            endforeach(ex)
        
            set(CPPCHECK_ALL_ARGS 
                ${CPPCHECK_THREADS_ARG} 
                ${CPPCHECK_PROJECT_ARG} 
                ${CPPCHECK_BUILD_DIR_ARG} 
                ${CPPCHECK_ERROR_EXITCODE_ARG} 
                ${CPPCHECK_SUPPRESSIONS} 
                ${CPPCHECK_EXITCODE_SUPPRESSIONS}
                ${CPPCHECK_CHECKS_ARGS} 
                ${CPPCHECK_OTHER_ARGS}
                ${CPPCHECK_EXCLUDES}
            )
        
            # run cppcheck command with optional xml output for CI system
            if(NOT CPPCHECK_XML_OUTPUT)
                set(CPPCHECK_COMMAND 
                    ${CPPCHECK_BIN}
                    ${CPPCHECK_ALL_ARGS}
                )
            else()
                set(CPPCHECK_COMMAND
                    ${CPPCHECK_BIN}
                    ${CPPCHECK_ALL_ARGS}
                    --xml 
                    --xml-version=2
                    2> ${CPPCHECK_XML_OUTPUT})
            endif()
        endif(CPPCHECK_BIN)
        
        # handle the QUIETLY and REQUIRED arguments 
        # and set YAMLCPP_FOUND to TRUE if all listed variables are TRUE
        include(FindPackageHandleStandardArgs)
        FIND_PACKAGE_HANDLE_STANDARD_ARGS(
            CPPCHECK 
            DEFAULT_MSG 
            CPPCHECK_BIN
        )
        
        # prevent user from tampering with internal vars
        mark_as_advanced(
            CPPCHECK_BIN  
            CPPCHECK_THREADS_ARG
            CPPCHECK_PROJECT_ARG
            CPPCHECK_BUILD_DIR_ARG
            CPPCHECK_ERROR_EXITCODE_ARG
            CPPCHECK_SUPPRESSIONS
            CPPCHECK_EXITCODE_SUPPRESSIONS
            CPPCHECK_CHECKS_ARGS
            CPPCHECK_EXCLUDES
            CPPCHECK_OTHER_ARGS
        )
        
        # If found add a cppcheck-analysis target
        if(CPPCHECK_FOUND)
            if(NOT TARGET cppcheck-analysis)
                if(NOT IS_DIRECTORY "${CMAKE_BINARY_DIR}/analysis")
                    file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/analysis")
                endif(NOT IS_DIRECTORY "${CMAKE_BINARY_DIR}/analysis")

                if(NOT IS_DIRECTORY "${CMAKE_BINARY_DIR}/analysis/cppcheck")
                    file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/analysis/cppcheck")
                endif(NOT IS_DIRECTORY "${CMAKE_BINARY_DIR}/analysis/cppcheck")

                if(NOT IS_DIRECTORY "${CMAKE_BINARY_DIR}/analysis/cppcheck")
                    file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/analysis/cppcheck")
                endif(NOT IS_DIRECTORY "${CMAKE_BINARY_DIR}/analysis/cppcheck")
                
                add_custom_target(cppcheck-analysis ALL DEPENDS ${target_list})
                add_custom_command(
                    TARGET cppcheck-analysis
                    POST_BUILD
                    DEPENDS ${target_list}
                    COMMENT "Performing static analysis with cppcheck"
                    COMMAND ${CPPCHECK_COMMAND}
                )
            endif(NOT TARGET cppcheck-analysis)
        else()
            message("cppcheck not found. No cppccheck-analysis targets")
        endif()
    endif(PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
endfunction(add_cppcheck)
