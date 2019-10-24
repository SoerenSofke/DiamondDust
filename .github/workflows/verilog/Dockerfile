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
    PATH=$PATH:/opt/riscv32i/bin

### Copy RISCV from builder image ###
COPY --from=soerensofke/diamonddust:riscvGnuToolchainRv32i $RISCV/ $RISCV/    

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success"

### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }              
