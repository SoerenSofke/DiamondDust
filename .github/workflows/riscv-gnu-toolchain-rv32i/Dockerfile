FROM ubuntu:18.04 AS builder

USER root

### Several standard packages are needed to build the RISC-V toolchain ###
RUN yes | unminimize \
    && apt-get update \
    && apt-get install -yq \
        autoconf \
        automake \
        autotools-dev \
        curl libmpc-dev \
        libmpfr-dev \
        libgmp-dev \
        gawk \
        build-essential \
        bison \
        flex \
        texinfo \
        gperf \
        libtool \
        patchutils \
        bc \
        zlib1g-dev \
        libexpat-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
    
### Specify work directory and install directory ###
ENV TOP /opt
ENV RISCV $TOP/riscv32i
ENV PATH $PATH:$RISCV/bin   

### Get sources, build and test RISC-V toolchain ###
RUN git clone --recursive --branch v20180629 https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i \
    && cd riscv-gnu-toolchain-rv32i \
    && ./configure --with-arch=rv32i --prefix=$RISCV \
    && make \
    && echo 'int main(void) { return 0; }' > hello.c \
    && riscv32-unknown-elf-gcc -o hello hello.c \
    && cd .. \
    && rm -rf riscv-gnu-toolchain-rv32i \
    
