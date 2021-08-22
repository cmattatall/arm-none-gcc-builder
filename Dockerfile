FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y \
        git \
        wget \
        curl \
        build-essential \
        gcc-arm-none-eabi
