FROM quay.io/spivegin/golangnodesj

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    apt-transport-https \
    ca-certificates \
    curl

RUN curl -fsSL -O https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
    && dpkg -i dumb-init_1.2.0_amd64.deb && rm dumb-init_1.2.0_amd64.deb

# CMD ["/usr/bin/dumb-init", "--"]

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo 'deb https://deb.nodesource.com/node_8.x stretch main' | tee /etc/apt/sources.list.d/nodesource.list \
    && curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list


RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    bzip2 \
    clang \
    cmake \
    file \
    flex \
    g++ \
    gawk \
    git \
    golang \
    gperf \
    help2man \
    iptables \
    make \
    nodejs \
    openssh-client \
    patch \
    python \
    texinfo \
    unzip \
    xz-utils \
    yarn \
    libtinfo5 \
    libtinfo-dev \
    libncurses5 \
    libncurses5-dev \
    build-essential 

# autoconf - crosstool-ng/bootstrap
# bison - crosstool-ng/configure
# bzip2 - crosstool-ng/configure
# clang - msan: -fsanitize
# cmake - msan: libcxx
# file - crosstool-ng/build
# flex - crosstool-ng/configure
# g++ - crosstool-ng/build
# gawk - crosstool-ng/configure
# git - crosstool-ng/configure
# golang - go: bootstrap
# gperf - crosstool-ng/configure
# help2man - crosstool-ng/configure
# iptables - acceptance tests' partition nemesis
# libncurses-dev - crosstool-ng/configure
# make - crosstool-ng boostrap / CRDB build system
# nodejs - ui: all
# openssh-client - terraform / jepsen
# patch - crosstool-ng/configure
# python - msan: libcxx
# texinfo - crosstool-ng/configure
# unzip - terraform
# xz-utils - msan: libcxx / CRDB build system
# yarn - ui: all
RUN mkdir crosstool-ng \
    && curl -fsSL http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.xz | tar --strip-components=1 -C crosstool-ng -xJ \
    && cd crosstool-ng \
    && ./configure --prefix /usr/local/ct-ng \
    && make -j$(nproc) \
    && make install \
    && cp ct-ng.comp /etc/bash_completion.d/ \
    && cd .. \
    && rm -rf crosstool-ng