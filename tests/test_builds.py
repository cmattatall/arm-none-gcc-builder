import os
import platform
import argparse
import shutil

# Shamelessly copied from
# https://stackoverflow.com/questions/15316398/check-a-commands-return-code-when-subprocess-raises-a-calledprocesserror-except
#
# There definitely is a better way to do it, but we just need to check the 
# return value of a process in a platform-agnostic way.
# 
# In the future, we should use ctest to execute a multi-configuration cmake build stage as part of the tests. 
# something like:
# 
#   add_test(....
#       COMMAND ${CMAKE_COMMAND} -S ${CMAKE_SOURCE_DIR} -B ${CMAKE_BINARY_DIR} --toolchain=/path/to/toolchain/file/using/cmake/variables
#   )
#
#
#   add_test(....
#       COMMAND ${CMAKE_COMMAND} -S ${CMAKE_SOURCE_DIR} -B ${CMAKE_BINARY_DIR}
#   )
# 

import subprocess

cross_build_command='cmake -S . -B build_cross --toolchain=cmake/toolchains/arm-none-eabi-gcc-toolchain.cmake && cmake --build build_cross'
host_build_command='cmake -S . -B build_host && cmake --build build_host'
try:
    subprocess.check_output(cross_build_command, shell=True, stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
    print("Cross build failed")
    shutil.rmtree('build_cross')
    exit(1)
shutil.rmtree('build_cross')
print("Cross build succeeded")


try:
    subprocess.check_output(host_build_command, shell=True, stderr=subprocess.STDOUT)
except subprocess.CalledProcessError as e:
    print("Host build failed")
    shutil.rmtree('build_host')
    exit(1)
shutil.rmtree('build_host')
print("Host build succeeded")

