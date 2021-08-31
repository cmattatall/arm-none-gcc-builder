cmake_minimum_required(VERSION 3.21)

function(get_child_targets output_var dir)
    set(targets)
    get_all_targets_recursive(targets ${dir})
    set(${output_var} ${targets} PARENT_SCOPE)
endfunction(get_child_targets output_var dir)


function(get_all_targets output_var)
    set(targets)
    get_child_targets(targets ${CMAKE_SOURCE_DIR})
    set(${output_var} ${targets} PARENT_SCOPE)
endfunction(get_all_targets output_var)


macro(get_all_targets_recursive targets dir)
    get_property(subdirectories DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        get_all_targets_recursive(${targets} ${subdir})
    endforeach(subdir ${subdirectories})
    get_property(current_targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
    list(APPEND ${targets} ${current_targets})
endmacro()


function(get_child_tests output_var dir)
    set(tests)
    get_all_tests_recursive(tests ${dir})
    set(${output_var} ${tests} PARENT_SCOPE)
endfunction(get_child_tests output_var dir)


function(get_all_tests output_var)
    set(tests)
    get_child_tests(tests ${CMAKE_SOURCE_DIR})
    set(${output_var} ${tests} PARENT_SCOPE)
endfunction(get_all_tests output_var)


macro(get_all_tests_recursive tests cmake_dir)
    get_property(subdirectories DIRECTORY ${cmake_dir} PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        get_all_tests_recursive(${tests} ${subdir})
    endforeach(subdir ${subdirectories})
    get_property(current_tests DIRECTORY ${cmake_dir} PROPERTY TESTS)
    list(APPEND ${tests} ${current_tests})
endmacro(get_all_tests_recursive tests cmake_dir)

