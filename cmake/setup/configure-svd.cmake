cmake_minimum_required(VERSION 3.20)

FetchContent_Declare(
    svd
    GIT_REPOSITORY "https://github.com/cmattatall/cmsis-svd.git"
    GIT_TAG         8ac69ea17f3a8fdc3249f29109531d8b5907596d
)

FetchContent_MakeAvailable(svd)
