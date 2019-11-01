FROM ubuntu:18.04 AS builder

### Several standard packages are needed to build iStyle ###
RUN yes | unminimize \
    && apt-get update \
    && apt-get install --no-install-recommends -yq \
        autoconf \
        automake \
        autotools-dev \
        curl \
        libmpc-dev \
        libmpfr-dev \
        libgmp-dev \
        gawk \
        build-essential \
        bison \
        flex \
        texinfo \
        gperf \
        libtool \
        patchutils \
        bc \
        zlib1g-dev \
        libexpat-dev \
        git \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
