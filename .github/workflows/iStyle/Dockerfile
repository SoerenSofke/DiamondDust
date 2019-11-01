FROM soerensofke/diamonddust:builder AS builder

### Several standard packages are needed to build iStyle ###
RUN git clone https://github.com/thomasrussellmurphy/istyle-verilog-formatter.git iStyle \
    && cd iStyle \
    && make \
    && mkdir -p /opt/iStyle \
    && cp ./bin/release/iStyle /opt/iStyle/

### File iStyle only ###
FROM scratch AS final

### Copy iStyle ###
COPY --from=builder /opt/iStyle/ /opt/iStyle/
