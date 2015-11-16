FROM gocd/gocd-agent:latest

COPY install.sh /install.sh

RUN sudo apt-get update
RUN sudo apt-get install libjpeg-dev curl git git-core build-essential \
    python-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev -y

RUN /bin/bash /install.sh && rm /install.sh

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH