# arm-none-gcc-builder

Project to create a customizable build system for arm-based micros that runs on all platforms and prevents lock-in to vendor IDEs

# Dependencies 

- Docker (20.10.5 or greater)   https://www.docker.com/products/docker-desktop
- Python (3.6 or or greater)    https://www.python.org/downloads/

# Usage


# Building

With the necessary dependencies installed, execute `$python3 ./compile.py` from the root of the project

# Debugging

OpenOCD is used for debugging

For more information, consult https://openocd.org/

## Setup

### Windows


### Linux

#### UDev rules

# Tests


# Notes, Todo, and Future Work:

- Configuring OpenOCD
https://wiki.st.com/stm32mpu/wiki/GDB#Overview_of_GDB_setup_for_STM32MPU

- SVD parsers (cortex debug can be used in the meantime as a vscode extension but its not ideal because this should be environment agnostic)




