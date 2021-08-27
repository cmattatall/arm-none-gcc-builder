cmake_minimum_required(VERSION 3.21)

function(get_all_targets var)
    set(targets)
    get_all_targets_recursive(targets ${CMAKE_CURRENT_SOURCE_DIR})

    set(output_list "") # empty list
    foreach(target ${targets})
        get_target_property(type ${target} TYPE)
        set(current_target_list_entry "${target} (type: ${type})")
        list(APPEND output_list ${current_target_list_entry})
    endforeach(target ${targets})
    set(${var} ${output_list} PARENT_SCOPE)
endfunction()

macro(get_all_targets_recursive targets dir)
    get_property(subdirectories DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        get_all_targets_recursive(${targets} ${subdir})
    endforeach()

    get_property(current_targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
    list(APPEND ${targets} ${current_targets})
endmacro()

