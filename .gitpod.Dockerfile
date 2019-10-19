FROM gitpod/workspace-full

### iverilog ###
RUN yes | unminimize \
    && apt-get install -yq \
        iverilog \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
