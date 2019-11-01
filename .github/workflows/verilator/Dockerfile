FROM soerensofke/diamonddust:builder AS builder

### Several standard packages are needed to build verilator ###
RUN git clone https://github.com/poucotm/verilator.git verilator \
    && cd verilator \
    && autoconf \
    && unset VERILATOR_ROOT \
    && ./configure --prefix /opt/verilator \
    && make \
    && mkdir install
    
### File verilator only ###
FROM scratch AS final

### Copy verilator ###
COPY --from=builder /opt/verilator/ /opt/verilator/
