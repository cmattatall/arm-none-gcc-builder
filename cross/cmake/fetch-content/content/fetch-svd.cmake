cmake_minimum_required(VERSION 3.20)

FetchContent_Declare(
    svd
    GIT_REPOSITORY "https://github.com/cmattatall/cmsis-svd.git"
)

FetchContent_MakeAvailable(svd)
