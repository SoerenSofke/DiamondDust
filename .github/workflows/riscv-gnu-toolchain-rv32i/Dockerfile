FROM docker.pkg.github.com/soerensofke/diamonddust/builder:latest AS builder

### Specify install directory ###
ENV RISCV=/opt/riscv32i

### Several standard packages are needed to build the RISC-V toolchain ###
RUN git clone --recursive --branch v20180629 https://github.com/riscv/riscv-gnu-toolchain riscv-gnu-toolchain-rv32i \
    && cd riscv-gnu-toolchain-rv32i \
    && ./configure --with-arch=rv32i --prefix=$RISCV \
    && make -j 4 \
    && cd .. \
    && rm -rf riscv-gnu-toolchain-rv32i
        
### File RISC-V toolchain only ###
FROM scratch AS final
    
### Copy toolchain ###    
COPY --from=builder /opt/riscv32i/ /opt/riscv32i/   
