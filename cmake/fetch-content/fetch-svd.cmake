cmake_minimum_required(VERSION 3.21)

FetchContent_Declare(
    svd
    GIT_REPOSITORY "https://github.com/cmattatall/cmsis-svd.git"
)

FetchContent_MakeAvailable(svd)
