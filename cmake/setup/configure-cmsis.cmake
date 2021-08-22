cmake_minimum_required(VERSION 3.20)

FetchContent_Declare(
    cmsis
    GIT_REPOSITORY "https://github.com/cmattatall/CMSIS_5.git"
)

FetchContent_MakeAvailable(cmsis)
