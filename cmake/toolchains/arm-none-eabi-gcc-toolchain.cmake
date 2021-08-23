################################################################################
# BRIEF:
#
# CMake toolchain for an abstract toolchain configurable for various targets.
# The current example is configured for an stm32f411 microcontroller.
#
################################################################################
# Author: Carl Mattatall
# Maintainer: Carl Mattatall (cmattatall2@gmail.com)
# Github: cmattatall
################################################################################
cmake_minimum_required(VERSION 3.20)


# TODO: Refactor the target-specific stuff into an abstract and injectible
# configuration file at some point in the future

################################################################################
# CMAKE TOOLCHAIN OPTIONS: CHANGE THESE BASED ON YOUR EMBEDDED TARGET
################################################################################
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(TOOLCHAIN_PREFIX arm-none-eabi)


################################################################################
# LINKER OPTIONS: CHANGE THESE BASED ON YOUR EMBEDDED TARGET
################################################################################
set(CODEGEN_OPTIONS 
    "                       \
    -mthumb-interwork       \
    -ffreestanding          \
    -ffunction-sections     \
    -fdata-sections         \
    -fomit-frame-pointer    \
    -mabi=aapcs             \
    --specs=nano.specs      \
    --specs=nosys.specs     \
    "
)
################################################################################
# Additional reading if interested: 
# https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
################################################################################

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_CROSSCOMPILING ON)

# BINUTILS NAMES 
#(files with these names in PATH may not necessarily be true paths - could be links, aliases, etc.)
set(TOOLCHAIN_C_COMPILER_NAME ${TOOLCHAIN_PREFIX}-gcc${CMAKE_EXECUTABLE_SUFFIX})
set(TOOLCHAIN_ASM_COMPILER_NAME ${TOOLCHAIN_C_COMPILER_NAME}) # use same ASM compiler as C compiler for ABI compat
set(TOOLCHAIN_CXX_COMPILER_NAME ${TOOLCHAIN_PREFIX}-g++${CMAKE_EXECUTABLE_SUFFIX})
set(TOOLCHAIN_OBJCOPY_NAME ${TOOLCHAIN_PREFIX}-objcopy${CMAKE_EXECUTABLE_SUFFIX})
set(TOOLCHAIN_OBJDUMP_NAME ${TOOLCHAIN_PREFIX}-objdump${CMAKE_EXECUTABLE_SUFFIX})
set(TOOLCHAIN_SIZE_NAME ${TOOLCHAIN_PREFIX}-size${CMAKE_EXECUTABLE_SUFFIX})
set(TOOLCHAIN_GDB_NAME ${TOOLCHAIN_PREFIX}-gdb${CMAKE_EXECUTABLE_SUFFIX})

# Print configuration info to callee
if(NOT DEFINED ENV{TOOLCHAIN_PROCESSED})

    # cmake can process the toolchain file multiple times but we only want
    # to emit the configuration info to the caller the very first time it is
    # processed so that stdout doens't get flooded. 
    #
    # To do this, we use (an admittedly hacky) environment variable to maintain
    # the statefulness of the cache population, try_compile() and try_run()
    # stages
    #
    # Hopefully in the future, cmake will provide a better or standard way
    # to issue diagnostics when processing a toolchain file
    message("") 
    message("Configured toolchain binutils: ")
    message("TOOLCHAIN_C_COMPILER_NAME ......... ${TOOLCHAIN_C_COMPILER_NAME}")
    message("TOOLCHAIN_ASM_COMPILER_NAME ....... ${TOOLCHAIN_ASM_COMPILER_NAME}")
    message("TOOLCHAIN_CXX_COMPILER_NAME ....... ${TOOLCHAIN_CXX_COMPILER_NAME}")
    message("TOOLCHAIN_OBJCOPY_NAME ............ ${TOOLCHAIN_OBJCOPY_NAME}")
    message("TOOLCHAIN_OBJDUMP_NAME ............ ${TOOLCHAIN_OBJDUMP_NAME}")
    message("TOOLCHAIN_SIZE_NAME ............... ${TOOLCHAIN_SIZE_NAME}")
    message("TOOLCHAIN_GDB_NAME ................ ${TOOLCHAIN_GDB_NAME}")
    message("TOOLCHAIN_STRIP_NAME .............. ${TOOLCHAIN_STRIP_NAME}")
    message("") 

    mark_as_advanced(TOOLCHAIN_PREFIX)
    mark_as_advanced(TOOLCHAIN_C_COMPILER_NAME)
    mark_as_advanced(TOOLCHAIN_ASM_COMPILER_NAME)
    mark_as_advanced(TOOLCHAIN_CXX_COMPILER_NAME)
    mark_as_advanced(TOOLCHAIN_OBJCOPY_NAME)
    mark_as_advanced(TOOLCHAIN_OBJDUMP_NAME)
    mark_as_advanced(TOOLCHAIN_SIZE_NAME)
    mark_as_advanced(TOOLCHAIN_GDB_NAME)
    mark_as_advanced(TOOLCHAIN_STRIP_NAME)

endif(NOT DEFINED ENV{TOOLCHAIN_PROCESSED})

if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_COMMAND where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_COMMAND which)
else()
    message(FATAL_ERROR "SYSTEM : ${CMAKE_HOST_SYSTEM_NAME} not supported")
endif()
mark_as_advanced(UTIL_SEARCH_COMMAND)

execute_process(
    COMMAND ${UTIL_SEARCH_COMMAND} ${TOOLCHAIN_C_COMPILER_NAME}
    OUTPUT_VARIABLE TOOLCHAIN_BINUTILS_PATH
    RESULT_VARIABLE TOOLCHAIN_BINUTILS_NOT_FOUND
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

mark_as_advanced(TOOLCHAIN_BINUTILS_PATH)
mark_as_advanced(TOOLCHAIN_BINUTILS_NOT_FOUND)

if(TOOLCHAIN_BINUTILS_NOT_FOUND)
    message(FATAL_ERROR "Could not find ${TOOLCHAIN_C_COMPILER_NAME}")
else()
    message("Found gcc executable at ${TOOLCHAIN_BINUTILS_PATH}")
endif(TOOLCHAIN_BINUTILS_NOT_FOUND)

################################################################################
# The found binary could be a link so we will try 
# to infer the toolchain directory from it.
# 
# If we can't follow a link the process to determine 
# the target sysroot becomes much more complicated....
################################################################################

if(MINGW OR CYGWIN OR WIN32)

    # TODO: on windows, we SHOULD follow links but this functionality isn't implemented yet
    # because an accessible tool like readlink isn't easily available on that platform
    #
    # In general, Windows users don't tend to have a 
    # deep understand how filesystems work anyways...
    # 
    # ¯\_(ツ)_/¯
    #     \/
    #     xx
    #     xx
    #    _/\_
    #     
    # For now we will just assume the binary in PATH is not a link
    set(TOOLCHAIN_GCC_PATH ${TOOLCHAIN_BINUTILS_PATH}) 

elseif(UNIX AND NOT APPLE)
    if(IS_SYMLINK TOOLCHAIN_BINUTILS_PATH)
        execute_process(
            COMMAND readlink -f ${TOOLCHAIN_BINUTILS_PATH}
            OUTPUT_VARIABLE TOOLCHAIN_GCC_PATH
            RESULT_VARIABLE TOOLCHAIN_GCC_PATH_NOT_FOUND
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    else()
        # The path we found for the GCC binary is in PATH is indeed a true path
        set(TOOLCHAIN_GCC_PATH ${TOOLCHAIN_BINUTILS_PATH})
    endif(IS_SYMLINK TOOLCHAIN_BINUTILS_PATH)
else()
    message(FATAL_ERROR "${CMAKE_HOST_SYSTEM_NAME} not supported")
endif()


if(NOT TOOLCHAIN_GCC_PATH)
    message(FATAL_ERROR "Could not infer directory for toolchain:${TOOLCHAIN_PREFIX} from ${TOOLCHAIN_BINUTILS_PATH}")
elseif(TOOLCHAIN_GCC_PATH_NOT_FOUND)
    message(FATAL_ERROR "Could not infer directory for toolchain:${TOOLCHAIN_PREFIX} from ${TOOLCHAIN_BINUTILS_PATH}")
endif()


get_filename_component(TOOLCHAIN_BINUTILS_DIR ${TOOLCHAIN_GCC_PATH} DIRECTORY)
get_filename_component(TOOLCHAIN_ROOT_DIR ${TOOLCHAIN_BINUTILS_DIR} DIRECTORY)
set(TOOLCHAIN_SYSROOT_DIR ${TOOLCHAIN_ROOT_DIR}/${TOOLCHAIN_PREFIX}) # TODO: check if sysroot is indeed a directory
list(APPEND TOOLCHAIN_BINUTILS_SEARCH_HINTS "${TOOLCHAIN_BINUTILS_DIR}")


if(MINGW OR CYGWIN OR WIN32)

    # Todo: Set up search hints for windows systems

elseif(UNIX AND NOT APPLE)

    set(TOOLCHAIN_USR_DIR ${TOOLCHAIN_SYSROOT_DIR}/usr)

    # Configure search mode for toolchain binutils on HOST (operate on target binaries but executed on host)
    set(CMAKE_PREFIX_PATH "" CACHE STRING "" FORCE)
    set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${TOOLCHAIN_SYSROOT_DIR}" CACHE STRING "" FORCE)
    set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${TOOLCHAIN_USR_DIR}" CACHE STRING "" FORCE)
    set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${TOOLCHAIN_USR_DIR}/local" CACHE STRING "" FORCE)
elseif(UNIX AND APPLE)

    # Todo: Set up search hints for apple systems

else()
    message(FATAL_ERROR "${CMAKE_HOST_SYSTEM_NAME} not supported")
endif()

set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PREFIX}/${${TOOLCHAIN}} ${CMAKE_PREFIX_PATH})
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_ROOT_DIR})
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)


find_program(
    CMAKE_C_COMPILER 
    NAMES ${TOOLCHAIN_C_COMPILER_NAME}
    HINTS ${TOOLCHAIN_BINUTILS_SEARCH_HINTS}
    REQUIRED
)

find_program(
    CMAKE_ASM_COMPILER 
    NAMES ${TOOLCHAIN_ASM_COMPILER_NAME}
    HINTS ${TOOLCHAIN_BINUTILS_SEARCH_HINTS}
    REQUIRED
)

find_program(
    CMAKE_CXX_COMPILER 
    NAMES ${TOOLCHAIN_CXX_COMPILER_NAME}
    HINTS ${TOOLCHAIN_BINUTILS_SEARCH_HINTS}
    REQUIRED
)

find_program(
    CMAKE_OBJCOPY 
    NAMES ${TOOLCHAIN_OBJCOPY_NAME}
    HINTS ${TOOLCHAIN_BINUTILS_SEARCH_HINTS}
    REQUIRED
)

find_program(
    CMAKE_OBJDUMP 
    NAMES ${TOOLCHAIN_OBJDUMP_NAME}
    HINTS ${TOOLCHAIN_BINUTILS_SEARCH_HINTS}
    REQUIRED
)

find_program(
    CMAKE_SIZE 
    NAMES ${TOOLCHAIN_SIZE_NAME}
    HINTS ${TOOLCHAIN_BINUTILS_SEARCH_HINTS}
    REQUIRED
)


# Note that GDB may not necessarily be required because we could be semihosting
# (or maybe we just don't care about debugging on our platform or something)
find_program(
    CMAKE_GDB 
    NAMES ${TOOLCHAIN_GDB_NAME}
    HINTS ${TOOLCHAIN_BINUTILS_SEARCH_HINTS} 
)

# Configure initial compiler flags
set(CMAKE_ASM_FLAGS_INIT "${CODEGEN_OPTIONS}")
set(CMAKE_C_FLAGS_INIT "${CODEGEN_OPTIONS}")
set(CMAKE_CXX_FLAGS_INIT "${CODEGEN_OPTIONS} -fno-rtti -fno-exceptions")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--relax,--gc-sections")

mark_as_advanced(CMAKE_ASM_FLAGS_INIT)
mark_as_advanced(CMAKE_C_FLAGS_INIT)
mark_as_advanced(CMAKE_CXX_FLAGS_INIT)

# This supports custom builds of gcc that may not use the default values 
# provided by autotools when it was built. 
#
# Examples: Yocto, OE, Alpine toolchains, or anything built using chroot
set(CMAKE_INSTALL_RPATH ${TOOLCHAIN_USR_DIR})
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)



#-------------------------------------------------------------------------------
# Prints the section sizes
#-------------------------------------------------------------------------------
function(print_section_sizes TARGET)
    add_custom_command(
        TARGET ${TARGET} 
        POST_BUILD 
        COMMAND ${CMAKE_SIZE} ${TARGET}
    )
endfunction()


#-------------------------------------------------------------------------------
# Creates output in hex format
#-------------------------------------------------------------------------------
function(create_hex_output TARGET)
    if(TARGET ${TARGET})
        add_custom_target(
            ${TARGET}.hex ALL 
            DEPENDS ${TARGET} 
            COMMAND ${CMAKE_OBJCOPY} -Oihex ${TARGET} ${TARGET}.hex
        )
    else()
        message(FATAL_ERROR "Target ${TARGET} is not a target. function ${CMAKE_CURRENT_FUNCTION_} cannot proceed.")
    endif(TARGET ${TARGET})
endfunction()


#-------------------------------------------------------------------------------
# Creates output in binary format
#-------------------------------------------------------------------------------
function(create_bin_output TARGET)
    if(TARGET ${TARGET})

        add_custom_target(
            ${TARGET}.bin ALL 
            DEPENDS ${TARGET} 
            COMMAND ${CMAKE_OBJCOPY} -Obinary ${TARGET} ${TARGET}.bin
        )
    else()
        message(FATAL_ERROR "Target ${TARGET} is not a target. function ${CMAKE_CURRENT_FUNCTION_} cannot proceed.")
    endif(TARGET ${TARGET})
endfunction()


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
            add_custom_target(
                ${TARGET}.lss ALL 
                DEPENDS ${TARGET} 
                COMMAND ${CMAKE_OBJDUMP} -xh ${OUTPUT_DIRECTORY}/${TARGET} > "${OUTPUT_DIRECTORY}/${LIB_NAME_BASE}.lss"
                VERBATIM
                add_custom_command()
            )
        else()
            message(WARNING "Target: ${TARGET} is not valid for generating listfile output.")
        endif(${TARGET}_IS_VALID)
    else()
        message(FATAL_ERROR "Target ${TARGET} is not a target. function ${CMAKE_CURRENT_FUNCTION_} cannot proceed.")
    endif(TARGET ${TARGET})
endfunction()

#[[
add_custom_command( 
            TARGET ${library}_postbuild
            POST_BUILD
            DEPENDS ALL
            COMMENT "Generating lss file for target: ${library}"
            COMMAND ${CMAKE_OBJDUMP} -xh "${OUTPUT_DIRECTORY}/${LIB_NAME}" > "${OUTPUT_DIRECTORY}/${LIB_NAME_BASE}.lss"
        )
#]]


#[[
if(NOT COMMAND _add_executable)
function(add_executable exe)
    _add_executable(${exe} ${ARGN})
    if(CMAKE_CROSSCOMPILING)
        set(SUFFIX ".elf")
        set(OUTPUT_NAME "${exe}")
        set(EXE_NAME "${OUTPUT_NAME}${SUFFIX}")

        set(OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/${exe}")
        if(NOT EXISTS "${OUTPUT_DIRECTORY}")
            file(MAKE_DIRECTORY "${OUTPUT_DIRECTORY}")
        endif(NOT EXISTS "${OUTPUT_DIRECTORY}")

        set_target_properties(${exe} PROPERTIES SUFFIX "${SUFFIX}")
        set_target_properties(${exe} PROPERTIES OUTPUT_NAME "${OUTPUT_NAME}")
        set_target_properties(${exe} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${OUTPUT_DIRECTORY}")    

        # Custom targets are always considered out of date so the postbuild tasks will always run
        add_custom_target(${exe}_postbuild ALL DEPENDS ${exe})

        add_custom_command(
            TARGET ${exe}_postbuild
            POST_BUILD
            DEPENDS ${exe}
            COMMENT "Built executable target: \"${exe}\" with the following size:"
            COMMAND ${CMAKE_SIZE} -B "${OUTPUT_DIRECTORY}/${EXE_NAME}"
            VERBATIM
        )

        # Generate hex file from the ELF
        add_custom_command(
            TARGET ${exe}_postbuild
            POST_BUILD
            DEPENDS ${exe}
            COMMENT "Producing a hex format for target: ${exe}"
            COMMAND ${CMAKE_OBJCOPY} -O ihex "${OUTPUT_DIRECTORY}/${EXE_NAME}" "${OUTPUT_DIRECTORY}/${exe}.hex"
            VERBATIM
        )

        # Generate binary file from the ELF
        add_custom_command(
            TARGET ${exe}_postbuild
            POST_BUILD
            DEPENDS ${exe}
            COMMENT "Producing a binary format for target: ${exe}"
            COMMAND ${CMAKE_OBJCOPY} -O binary "${OUTPUT_DIRECTORY}/${EXE_NAME}" "${OUTPUT_DIRECTORY}/${exe}.bin"
            VERBATIM
        )

        # Generate section list file from the ELF
        add_custom_command(
            TARGET ${exe}_postbuild
            POST_BUILD
            DEPENDS ${exe}
            COMMENT "Generating lss file for target: ${exe}"
            COMMAND ${CMAKE_OBJDUMP} -xh "${OUTPUT_DIRECTORY}/${EXE_NAME}" > "${OUTPUT_DIRECTORY}/${exe}.lss"
            VERBATIM
        )

    endif(CMAKE_CROSSCOMPILING)
endfunction(add_executable exe)
endif(NOT COMMAND _add_executable)
#]]





#[[
if(NOT COMMAND _add_library)
function(add_library library)
    _add_library(${library} ${ARGN})
    if(CMAKE_CROSSCOMPILING)

        set(PREFIX "lib")
        set(OUTPUT_NAME "${library}")
        set(OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/lib/${library}")
        if(NOT EXISTS "${OUTPUT_DIRECTORY}")
            file(MAKE_DIRECTORY "${OUTPUT_DIRECTORY}")
        endif(NOT EXISTS "${OUTPUT_DIRECTORY}")

        get_target_property(LIBRARY_TYPE ${library} TYPE)
        if(LIBRARY_TYPE STREQUAL STATIC_LIBRARY)
            set(SUFFIX ".a")
        elseif(LIBRARY_TYPE STREQUAL SHARED_LIBRARY)
            set(SUFFIX ".so")
        elseif(LIBRARY_TYPE STREQUAL MODULE_LIBRARY)
            set(SUFFIX ".module")
        elseif(LIBRARY_TYPE STREQUAL OBJECT_LIBRARY)
            set(SUFFIX ".o")
        elseif(LIBRARY_TYPE STREQUAL INTERFACE_LIBRARY)
            set(SUFFIX ".interface")
        else()
            set(SUFFIX "")
        endif()

        set(LIB_NAME_BASE "${PREFIX}${OUTPUT_NAME}")
        set(LIB_NAME "${LIB_NAME_BASE}${SUFFIX}")

        set_target_properties(${library} PROPERTIES SUFFIX "${SUFFIX}")
        set_target_properties(${library} PROPERTIES OUTPUT_NAME "${OUTPUT_NAME}")

        # Sadly cmake handles static libraries and shared libraries differently :(
        set_target_properties(${library} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${OUTPUT_DIRECTORY}")
        set_target_properties(${library} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${OUTPUT_DIRECTORY}")
        set_target_properties(${library} PROPERTIES PREFIX "${PREFIX}")

        # Custom targets are always considered out of date so the postbuild tasks will always run
        add_custom_target(${library}_postbuild ALL DEPENDS ${library})

        add_custom_command(
            TARGET ${library}_postbuild
            POST_BUILD
            DEPENDS ${library}
            COMMENT "Built library target: \"${library}\" with the following size:"
            COMMAND ${CMAKE_SIZE} -B "${OUTPUT_DIRECTORY}/${LIB_NAME}"
            VERBATIM
        )

        add_custom_command(
            TARGET ${library}_postbuild
            POST_BUILD
            DEPENDS ALL
            COMMENT "Generating lss file for target: ${library}"
            COMMAND ${CMAKE_OBJDUMP} -xh "${OUTPUT_DIRECTORY}/${LIB_NAME}" > "${OUTPUT_DIRECTORY}/${LIB_NAME_BASE}.lss"
            VERBATIM
        )

    endif(CMAKE_CROSSCOMPILING)
endfunction(add_library library)
endif(NOT COMMAND _add_library)
#]]

# The hacky workaround so that we can check if this is the very first time
# the toolchain file is being processed and act accordingly.
set(ENV{TOOLCHAIN_PROCESSED} 1)