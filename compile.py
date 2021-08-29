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

def crtl_c_exit(sig, frame):
    print('You pressed Ctrl+C! Exiting')
    sys.exit(0)
signal.signal(signal.SIGINT, crtl_c_exit)

def checkPythonVersion():
    if sys.version_info.major < 3: # python 3 must be the runtime
        raise Exception("%s must be executed using Python 3" % (os.path.basename(__file__)))


if __name__ == "__main__":
    checkPythonVersion()

    parser = argparse.ArgumentParser(description="parse command line args for docker build script")
    parser.add_argument("--cross", action="store_true", dest="crosscompiling", help="Option to cross compile")
    parser.add_argument("--release", action="store_true", dest="release_build", help="Build the project as a release build")

    args = parser.parse_args()

    build_tree_dir = "build"

    configure_command = "cmake -S . -B %s " % (build_tree_dir)
    build_command = "cmake --build %s " % (build_tree_dir)
    if(args.crosscompiling):
        pass
        configure_command += " %s " % ("--toolchain=cmake/toolchains/arm-none-eabi-gcc-toolchain.cmake")
        if(args.release_build):
            configure_command += " %s " % ("-DPRODUCTION=1")
    else:
        pass

    os.system(configure_command)
    os.system(build_command)