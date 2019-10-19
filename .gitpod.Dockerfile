FROM gitpod/workspace-full

USER root

### iverilog ###
RUN yes | unminimize \
    && apt-get install -yq \
        iverilog \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
