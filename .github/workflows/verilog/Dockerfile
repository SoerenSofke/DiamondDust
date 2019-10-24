### Here we build the final image to be used on gitpod ###
FROM ubuntu:18.04 AS final

### Install HDL-tools ###
RUN yes | unminimize \
    && apt-get update \
    && apt-get install --no-install-recommends -yq \
        fish \
        make \
        less \
        wget \
        libmpc-dev \
        iverilog \
        verilator \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    # Download and extract icestrom toolchain
    && wget --no-check-certificate https://github.com/FPGAwars/toolchain-icestorm/releases/download/v1.11.1/toolchain-icestorm-linux_x86_64-1.11.1.tar.gz -O - | tar -xz -C /usr/local \

### Specify install directory ###
ENV RISCV=/opt/riscv32i \
    PATH=$PATH:/opt/riscv32i/bin \
    PS1="\[\]\[\]\u\[\] \[\]\w\[\] \$"

### Copy RISCV from builder image ###
COPY --from=soerensofke/diamonddust:riscvGnuToolchainRv32i $RISCV/ $RISCV/
