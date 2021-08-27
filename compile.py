import os
import platform
import argparse



if __name__ == "__main__":
    os.system("cmake -S . -B build --toolchain=cmake/toolchains/arm-none-eabi-gcc-toolchain.cmake")
    os.system("cmake --build build")