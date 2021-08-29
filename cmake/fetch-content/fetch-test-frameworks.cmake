cmake_minimum_required(VERSION 3.21)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        2f80c2ba71c0e8922a03b9b855e5b019ad1f7064 # release-1.10.0
)
FetchContent_MakeAvailable(googletest)


FetchContent_Declare(
    Catch2
    GIT_REPOSITORY https://github.com/catchorg/Catch2.git
    GIT_TAG        c4e3767e265808590986d5db6ca1b5532a7f3d13 # v2.13.4
)
FetchContent_MakeAvailable(Catch2)

