FROM haskell:latest as cardano

RUN cabal update
RUN apt-get update -y
RUN apt-get install -y git libtool build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 -y

RUN git clone https://github.com/input-output-hk/libsodium


WORKDIR libsodium
RUN git checkout 66f017f1 && ./autogen.sh && ./configure &&  make
RUN make install

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
ENV VERSION_TAG=1.27.0

RUN mkdir /cardano
WORKDIR /cardano
RUN git clone https://github.com/input-output-hk/cardano-node.git
WORKDIR cardano-node
RUN  git fetch --all --recurse-submodules --tags && git tag && git checkout tags/$VERSION_TAG
RUN cabal configure --with-compiler=ghc-8.10.2
RUN echo  "package cardano-crypto-praos" >>  cabal.project.local && echo "  flags: -external-libsodium-vrf" >>  cabal.project.local

RUN cabal build all

RUN cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-node-$VERSION_TAG/x/cardano-node/build/cardano-node/cardano-node /bin/cardano-node
RUN cp -p dist-newstyle/build/x86_64-linux/ghc-8.10.2/cardano-cli-$VERSION_TAG/x/cardano-cli/build/cardano-cli/cardano-cli /bin/cardano-cli

RUN chmod +x /bin/cardano-cli
RUN /bin/cardano-cli --version



FROM ubuntu:latest

RUN apt update

COPY --from=cardano /usr/local/ /usr/local

ENV LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"


COPY --from=cardano /bin /usr/bin

RUN chmod +x /usr/bin/cardano-cli
RUN mkdir /database

COPY --from=cardano /usr/local/ /usr/local

WORKDIR /config

