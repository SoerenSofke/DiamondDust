### Here we build the final image to be used on gitpod ###
FROM ubuntu:18.04 AS final

### Gitpod user ###
RUN useradd -l -u 33333 -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # custom Bash prompt
    && { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc \
    ### Install HDL-tools ###
    && yes | unminimize \
    && apt-get install --no-install-recommends -yq \
        make \
        wget \
        luajit \
        libmpc-dev \
        iverilog \
        verilator \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    ### Download and extract icestrom toolchain ###
    && wget --no-check-certificate https://github.com/FPGAwars/toolchain-icestorm/releases/download/v1.11.1/toolchain-icestorm-linux_x86_64-1.11.1.tar.gz -O - | tar -xz -C /usr/local 

### Specify install directory ###
ENV RISCV=/opt/riscv32i \
    ISTYLE=/opt/iStyle \
    PATH=$PATH:/opt/riscv32i/bin:/opt/iStyle

### Copy RISCV from builder image ###
COPY --from=soerensofke/diamonddust:riscvGnuToolchainRv32i $RISCV/ $RISCV/

### Copy iStyle from builder image ###
COPY --from=soerensofke/diamonddust:iStyle $ISTYLE/ $ISTYLE/
