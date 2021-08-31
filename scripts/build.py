# Python script meant to built the various configurations of the cmake project
# NOT MEANT TO BE CALLED FROM NATIVE BUILD ENVIRONMENT. 
# IT IS MEANT TO BE INVOKED FROM INSIDE THE DOCKER BUILD CONTAINER
from genericpath import isdir, isfile
import os
import sys
import argparse
import shutil
import platform
import pathlib
import shutil
import json
import subprocess
import signal
import re

def crtl_c_exit(sig, frame):
    print('You pressed Ctrl+C! Exiting')
    sys.exit(0)
signal.signal(signal.SIGINT, crtl_c_exit)

def checkPythonVersion():
    if sys.version_info.major < 3: # python 3 must be the runtime
        raise Exception("%s must be executed using Python 3" % (os.path.basename(__file__)))

def wasPreviousBuildCrossCompiled(build_tree):
    if os.path.isdir(build_tree):
        cmake_cache_file = os.path.join(build_tree, "CMakeCache.txt")
        if(os.path.isfile(cmake_cache_file)):
            cross_compiling_enabled_regex = "^CMAKE_CROSSCOMPILING:BOOL=ON"
            with open(cmake_cache_file) as search:
                for line in search:
                    line = line.rstrip()  # remove '\n' at end of line
                    result = re.search(cross_compiling_enabled_regex, line)
                    if result != None:
                        return True
        else:
            print("cmake_cache_file : %s is not a file." % (cmake_cache_file))
    else:
        print("build_tree: " + str(build_tree) + " is not a directory")
    return False

def cleanCmakeBuildTree(build_tree):
    if(os.path.isdir(build_tree)):
        shutil.rmtree(build_tree)
    else:
        print("[WARNING] cannot clean file: %s . Reason: not a directory" % ( build_tree))


if __name__ == "__main__":
    checkPythonVersion()

    parser = argparse.ArgumentParser(description="parse command line args for docker build script")
    parser.add_argument("--cross", action="store_true", dest="crosscompiling", help="Option to cross compile")
    parser.add_argument("--release", action="store_true", dest="release_build", help="Build the project as a release build")
    parser.add_argument("--clean", action="store_true", dest="build_clean", help="Rebuild the entire project from source")
    parser.add_argument("--build_tree", action="store", default="build", dest="build_tree", help="Path to the root of the generated build tree")

    args = parser.parse_args()
    build_tree_dir = args.build_tree

    configure_command = "cmake -S . -B %s " % (build_tree_dir)
    build_command = "cmake --build %s " % (build_tree_dir)

    build_tree_cleaned = False
    if(args.crosscompiling):
        configure_command += " %s " % ("--toolchain=cmake/toolchains/arm-none-eabi-gcc-toolchain.cmake")

        if not wasPreviousBuildCrossCompiled(build_tree_dir):
            # We have to do a complete rebuild because every binary
            # object was compiled for a different arch
            cleanCmakeBuildTree(build_tree_dir)
            build_tree_cleaned = True
    else:
        if wasPreviousBuildCrossCompiled(build_tree_dir):
            # We have to do a complete rebuild because every binary
            # object was compiled for a different arch
            cleanCmakeBuildTree(build_tree_dir)
            build_tree_cleaned = True

    if(args.build_clean):
        if not build_tree_cleaned:
            cleanCmakeBuildTree(build_tree_dir)

    if(args.release_build):
        configure_command += " %s " % ("-DPRODUCTION=1")
    else:
        configure_command += " %s " % ("-DPRODUCTION=0 -DCMAKE_BUILD_TYPE=Debug")

    assert(build_tree_dir != None)

    os.system(configure_command)
    os.system(build_command)