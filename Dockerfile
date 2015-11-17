FROM phusion/baseimage:0.9.16
MAINTAINER David Deng <denghui.cn@gmail.com>

# install python tox
COPY install_tox.sh /install_tox.sh

RUN sudo apt-get update
RUN sudo apt-get install libjpeg-dev curl git-core build-essential \
    python-pip make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev -y

RUN /bin/bash /install_tox.sh && rm /install_tox.sh

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# install gocd-agent
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN apt-get update && apt-get install -y -q unzip openjdk-7-jre-headless git

RUN mkdir /etc/service/go-agent
ADD install.sh /etc/service/go-agent/run

ADD http://download.go.cd/gocd-deb/go-agent-15.2.0-2248.deb /tmp/go-agent.deb

WORKDIR /tmp
RUN dpkg -i /tmp/go-agent.deb
RUN sed -i 's/DAEMON=Y/DAEMON=N/' /etc/default/go-agent

CMD ["/sbin/my_init"]



