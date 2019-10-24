### Here we build the final image to be used on gitpod ###
FROM ubuntu:18.04 AS final

USER root

### Install HDL-tools ###
RUN yes | unminimize \
    && apt-get update \
    && apt-get install --no-install-recommends -yq \
        make \
        less \
        wget \
        unzip \
        libmpc-dev \
        iverilog \
        verilator \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    # Download and extract icestrom toolchain
    && wget --no-check-certificate https://github.com/FPGAwars/toolchain-icestorm/releases/download/v1.11.1/toolchain-icestorm-linux_x86_64-1.11.1.tar.gz -O - | tar -xz -C /usr/local \
    # Download and extract verilog formater
    && wget --no-check-certificate https://github.com/ericsonj/verilog-format/raw/master/bin/verilog-format-LINUX.zip -O tmp.zip && unzip tmp.zip -d /opt/verilog-format/ && rm tmp.zip
    
### Specify install directory ###
ENV RISCV=/opt/riscv32i \
    PATH=$PATH:$RISCV/bin

# Copy RISCV from builder image
COPY --from=soerensofke/diamonddust:riscvGnuToolchainRv32i $RISCV/ $RISCV/
