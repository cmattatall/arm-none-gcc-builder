# arm-none-gcc-builder

Project to create a customizable build system for arm-based micros that runs on all platforms and prevents lock-in to vendor IDEs

# Dependencies 

- Docker (20.10.5 or greater)   https://www.docker.com/products/docker-desktop
- Python (3.6 or or greater)    https://www.python.org/downloads/
- CMake  (3.21.0 or greater)    https://cmake.org/download/

# Usage

## Windows

Builds must be done inside the docker container. 

To start build the image, do `$docker build .` from inside the base of the repository

## Unix

You can either build the docker image with `$docker build .` and use it to compile your cmake projects, or build natively

# Building

# Tests
