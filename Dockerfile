FROM ubuntu:21.04
ARG USER=cardano
USER root

RUN apt update \ 
    && apt -uy dist-upgrade \
    && apt -y install make vim


RUN useradd -ms /bin/bash ${USER}

USER ${USER}
WORKDIR /home/${USER}
ENV PATH /home/${USER}/.local/bin:$PATH

RUN mkdir -p ~/.local/
COPY --chown=${USER}:root ./bin /home/${USER}/.local/bin/

# install cardano code
RUN echo PATH="$PATH:$HOME/.local/bin/" >> $HOME/.bashrc \
  && . ~/.bashrc

USER root
COPY --chown=${USER}:root ./lib /usr/local/lib/
RUN ldconfig
