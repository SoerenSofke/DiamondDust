FROM gitpod/workspace-full AS builder

USER root

### Specify work directory and RISC-V install directory ###
ENV TOP /opt
ENV RISCV $TOP/riscv32i
ENV PATH $PATH:$RISCV/bin

### Several standard packages are needed to build the toolchain ###
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

### Get sources and build ###
RUN git clone --recursive --branch v20180629 https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i \
    && cd riscv-gnu-toolchain-rv32i \
    && ./configure --with-arch=rv32i --prefix=$RISCV \
    && make \
    && cd .. \
    && rm -rf riscv-gnu-toolchain-rv32i

### Test the RISC-V gnu toolchain ###
RUN echo 'int main(void) { return 0; }' > hello.c \
    && riscv32-unknown-elf-gcc -o hello hello.c
