FROM gitpod/workspace-full

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
