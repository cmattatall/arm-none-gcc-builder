FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y \
        git \
        wget \
        curl \
        build-essential \

        # build-essential : gcc { native -> native }
        # use gcc native to build gcc { native -> embedded device }
        gcc-arm-none-eabi
RUN git clone https://github.com/cmattatall/multiple_cmake_install.git
RUN ./multiple_cmake_install/cmake_install.sh
RUN mkdir -p /opt/cross
WORKDIR /opt/cross
RUN wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.07/gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2
RUN tar -xvf gcc-arm-none-eabi-10.3-2021.07-x86_64-linux.tar.bz2
RUN echo "export PATH=$PATH:gcc-arm-none-eabi-10.3-2021.07/bin" >> ~/.bashrc
RUN apt-get install -y python3 python3-pip graphviz
