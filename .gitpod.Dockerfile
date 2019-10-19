FROM gitpod/workspace-full AS builder

### specify work directory and RISC-V install directory ###
ENV TOP /opt
ENV RISCV $TOP/riscv32i
ENV PATH $PATH:$RISCV/bin

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
    
### get sources and build ###
RUN git clone --recursive --branch v20180629 https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i
RUN cd riscv-gnu-toolchain-rv32i && ./configure --with-arch=rv32i --prefix=$RISCV && make    

### test the RISC-V gnu toolchain ###
RUN echo 'int main(void) { return 0; }' > hello.c \
  && riscv32-unknown-elf-gcc -o hello hello.c

FROM gitpod/workspace-full AS finalImage

USER root

### iverilog ###
RUN yes | unminimize \
    && apt-get update \
    && apt-get install -yq \
        iverilog \
        verilator \
        universal-ctags \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

### Download and extract icestrom toolchain ###
RUN wget --no-check-certificate https://github.com/FPGAwars/toolchain-icestorm/releases/download/v1.11.1/toolchain-icestorm-linux_x86_64-1.11.1.tar.gz -O - | tar -xz -C /usr/local

### Download and extract verilog-format ###
RUN wget --no-check-certificate https://github.com/ericsonj/verilog-format/raw/master/bin/verilog-format-LINUX.zip -O tmp.zip && unzip tmp.zip -d /opt/verilog-format/ && rm tmp.zip
