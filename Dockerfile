FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y \
        git \
        wget \
        curl \
        build-essential \
        gcc-arm-none-eabi
RUN git clone https://github.com/cmattatall/multiple_cmake_install.git
RUN ./multiple_cmake_install/cmake_install.sh
RUN mkdir /work
WORKDIR /work
COPY . .
RUN cmake -S . -B build

