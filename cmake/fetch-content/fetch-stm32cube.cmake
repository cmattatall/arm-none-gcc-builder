cmake_minimum_required(VERSION 3.21)

# SOME USEFUL HAL URLS FOR STM32
#
# https://github.com/STMicroelectronics/stm32l0xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32f0xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32l1xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32f1xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32f2xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32f3xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32l4xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32f4xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32g4xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32l5xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32f7xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32h7xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32wbxx_hal_driver.git
# https://github.com/STMicroelectronics/stm32wlxx_hal_driver.git
# https://github.com/STMicroelectronics/stm32g0xx_hal_driver.git
# https://github.com/STMicroelectronics/stm32u5xx_hal_driver.git


FetchContent_Declare(
    STM32F0
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeF0.git"
)
FetchContent_MakeAvailable(STM32F0)


FetchContent_Declare(
    STM32L0
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeL0.git"
)
FetchContent_MakeAvailable(STM32L0)


FetchContent_Declare(
    STM32L1
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeL1.git"
)
FetchContent_MakeAvailable(STM32L1)


FetchContent_Declare(
    STM32F1
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeF1.git"
)
FetchContent_MakeAvailable(STM32F1)


FetchContent_Declare(
    STM32F2
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeF2.git"
)
FetchContent_MakeAvailable(STM32F2)


FetchContent_Declare(
    STM32F3
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeF3.git"
)
FetchContent_MakeAvailable(STM32F3)

FetchContent_Declare(
    STM32F4
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeF4.git"
)
FetchContent_MakeAvailable(STM32F4)


FetchContent_Declare(
    STM32L4
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeL4.git"
)
FetchContent_MakeAvailable(STM32L4)


FetchContent_Declare(
    STM32L5
    GIT_REPOSITORY "https://github.com/STMicroelectronics/STM32CubeL5.git"
)
FetchContent_MakeAvailable(STM32L5)