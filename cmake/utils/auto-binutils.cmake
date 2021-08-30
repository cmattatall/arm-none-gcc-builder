cmake_minimum_required(VERSION 3.21)

if(NOT CMAKE_SIZE)
    set(CMAKE_SIZE "size${CMAKE_EXECUTABLE_SUFFIX}")
endif(NOT CMAKE_SIZE)

if(NOT CMAKE_OBJCOPY)
    set(CMAKE_OBJCOPY "objcopy${CMAKE_EXECUTABLE_SUFFIX}")
endif(NOT CMAKE_OBJCOPY)

if(NOT CMAKE_OBJDUMP)
    set(CMAKE_OBJDUMP "objdump${CMAKE_EXECUTABLE_SUFFIX}")
endif(NOT CMAKE_OBJDUMP)

if(NOT CMAKE_READELF)
    set(CMAKE_READELF "readelf${CMAKE_EXECUTABLE_SUFFIX}")
endif(NOT CMAKE_READELF)


#-------------------------------------------------------------------------------
# Prints the section sizes
#-------------------------------------------------------------------------------
function(print_section_sizes TARGET)

    if(TARGET ${TARGET})
        unset(${TARGET}_IS_VALID)
        get_target_property(TARGET_TYPE ${TARGET} TYPE)
        if(TARGET_TYPE)
            if(TARGET_TYPE STREQUAL STATIC_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL SHARED_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL MODULE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL OBJECT_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL INTERFACE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL EXECUTABLE)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} RUNTIME_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: RUNTIME_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL UTILITY)
                # This is for cmake's internal target types (and for targets added with add_custom_target)
                # We won't do anything because compiled files are not produced from these targets
            else()
                message(WARNING "Unsupported type: ${TARGET_TYPE} for target: \
                                ${TARGET} in function ${CMAKE_CURRENT_FUNCTION}")
            endif()
        else()
            message(WARNING "Property TYPE for target: ${TARGET} does not exist")
        endif(TARGET_TYPE)

        if(${TARGET}_IS_VALID)
            if(CMAKE_SIZE)
                add_custom_command(
                    TARGET ${TARGET}
                    POST_BUILD
                    DEPENDS ${TARGET}
                    COMMAND ${CMAKE_SIZE} ${TARGET}
                    COMMENT "Printing section sizes for target : ${TARGET}"
                    VERBATIM
                    WORKING_DIRECTORY ${OUTPUT_DIRECTORY}
                )
            else()
                message(WARNING "Cannot produce target to print section sizes for target: ${TARGET} because CMAKE_SIZE executable not defined")
            endif(CMAKE_SIZE)
        else()
            message(WARNING "Target: ${TARGET} is not valid for generating binary output.")
        endif(${TARGET}_IS_VALID)
    else()
        message(FATAL_ERROR "Target ${TARGET} is not a target. function ${CMAKE_CURRENT_FUNCTION_} cannot proceed.")
    endif(TARGET ${TARGET})
endfunction(print_section_sizes TARGET)


#-------------------------------------------------------------------------------
# Creates output in hex format
#-------------------------------------------------------------------------------
function(create_hex_output TARGET)
    if(TARGET ${TARGET})
        unset(${TARGET}_IS_VALID)
        get_target_property(TARGET_TYPE ${TARGET} TYPE)
        if(TARGET_TYPE)
            if(TARGET_TYPE STREQUAL STATIC_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL SHARED_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL MODULE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL OBJECT_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL INTERFACE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL EXECUTABLE)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} RUNTIME_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: RUNTIME_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL UTILITY)
                # This is for cmake's internal target types (and for targets added with add_custom_target)
                # We won't do anything because compiled files are not produced from these targets
            else()
                message(WARNING "Unsupported type: ${TARGET_TYPE} for target: \
                                ${TARGET} in function ${CMAKE_CURRENT_FUNCTION}")
            endif()
        else()
            message(WARNING "Property TYPE for target: ${TARGET} does not exist")
        endif(TARGET_TYPE)

        if(${TARGET}_IS_VALID)
            if(CMAKE_OBJCOPY)
                add_custom_target(
                    ${TARGET}.hex ALL
                    DEPENDS ${TARGET}
                    COMMAND ${CMAKE_OBJCOPY} -Oihex ${TARGET} ${TARGET}.hex
                    VERBATIM
                    WORKING_DIRECTORY ${OUTPUT_DIRECTORY}

                )
            else()
                message(WARNING "Cannot produce target to generate custom hex output for target: ${TARGET} because CMAKE_OBJCOPY executable not defined")
            endif(CMAKE_OBJCOPY)
        else()
            message(WARNING "Target: ${TARGET} is not valid for generating binary output.")
        endif(${TARGET}_IS_VALID)
    else()
        message(FATAL_ERROR "Target ${TARGET} is not a target. function ${CMAKE_CURRENT_FUNCTION_} cannot proceed.")
    endif(TARGET ${TARGET})
endfunction(create_hex_output TARGET)


#-------------------------------------------------------------------------------
# Creates output in binary format
#-------------------------------------------------------------------------------
function(create_bin_output TARGET)
    if(TARGET ${TARGET})

        unset(${TARGET}_IS_VALID)
        get_target_property(TARGET_TYPE ${TARGET} TYPE)
        if(TARGET_TYPE)
            if(TARGET_TYPE STREQUAL STATIC_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL SHARED_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL MODULE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL OBJECT_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL INTERFACE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL EXECUTABLE)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} RUNTIME_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: RUNTIME_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL UTILITY)
                # This is for cmake's internal target types (and for targets added with add_custom_target)
                # We won't do anything because compiled files are not produced from these targets
            else()
                message(WARNING "Unsupported type: ${TARGET_TYPE} for target: \
                                ${TARGET} in function ${CMAKE_CURRENT_FUNCTION}")
            endif()
        else()
            message(WARNING "Property TYPE for target: ${TARGET} does not exist")
        endif(TARGET_TYPE)

        if(${TARGET}_IS_VALID)
            if(CMAKE_OBJCOPY)
                add_custom_target(
                    ${TARGET}.bin ALL
                    DEPENDS ${TARGET}
                    COMMAND ${CMAKE_OBJCOPY} -Obinary ${TARGET} ${TARGET}.bin
                    VERBATIM
                    WORKING_DIRECTORY ${OUTPUT_DIRECTORY}
                )
            else()
                message(WARNING "Cannot produce target to generate custom binary output for target: ${TARGET} because CMAKE_OBJCOPY executable not defined")
            endif(CMAKE_OBJCOPY)
        else()
            message(WARNING "Target: ${TARGET} is not valid for generating binary output.")
        endif(${TARGET}_IS_VALID)
    else()
        message(FATAL_ERROR "Target ${TARGET} is not a target. function ${CMAKE_CURRENT_FUNCTION_} cannot proceed.")
    endif(TARGET ${TARGET})
endfunction(create_bin_output TARGET)



function(create_lss_output TARGET)
    if(TARGET ${TARGET})

        unset(${TARGET}_IS_VALID)
        get_target_property(TARGET_TYPE ${TARGET} TYPE)
        if(TARGET_TYPE)
            if(TARGET_TYPE STREQUAL STATIC_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL SHARED_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL MODULE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL OBJECT_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL INTERFACE_LIBRARY)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} ARCHIVE_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: ARCHIVE_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL EXECUTABLE)
                get_target_property(OUTPUT_DIRECTORY ${TARGET} RUNTIME_OUTPUT_DIRECTORY)
                if(OUTPUT_DIRECTORY)
                    set(${TARGET}_IS_VALID 1)
                else()
                    message(WARNING "Error. OUTPUT_DIRECTORY for target: ${TARGET}\
                                    with type: ${TARGET_TYPE} is empty.\
                                    Queried property: RUNTIME_OUTPUT_DIRECTORY")
                endif(OUTPUT_DIRECTORY)
            elseif(TARGET_TYPE STREQUAL UTILITY)
                # This is for cmake's internal target types (and for targets added with add_custom_target)
                # We won't do anything because compiled files are not produced from these targets
            else()
                message(WARNING "Unsupported type: ${TARGET_TYPE} for target: \
                                ${TARGET} in function ${CMAKE_CURRENT_FUNCTION}")
            endif()
        else()
            message(WARNING "Property TYPE for target: ${TARGET} does not exist")
        endif(TARGET_TYPE)

        if(${TARGET}_IS_VALID)
            if(CMAKE_OBJCOPY)
                add_custom_target(
                    ${TARGET}.lss ALL
                    DEPENDS ${TARGET}
                    COMMAND ${CMAKE_OBJDUMP} -xh ${TARGET} > "${TARGET}.lss"
                    VERBATIM
                    WORKING_DIRECTORY ${OUTPUT_DIRECTORY}
                )
            else()
                message(WARNING "Cannot produce target to generate custom binary output for target: ${TARGET} because CMAKE_OBJCOPY executable not defined")
            endif(CMAKE_OBJCOPY)
        else()
            message(WARNING "Target: ${TARGET} is not valid for generating listfile output.")
        endif(${TARGET}_IS_VALID)
    else()
        message(FATAL_ERROR "Target ${TARGET} is not a target. function ${CMAKE_CURRENT_FUNCTION_} cannot proceed.")
    endif(TARGET ${TARGET})
endfunction(create_lss_output TARGET)