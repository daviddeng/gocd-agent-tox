FROM phusion/baseimage:0.9.16
MAINTAINER David Deng <denghui.cn@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US.UTF-8 && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update \
    && apt-get -y install \
       python-software-properties software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN add-apt-repository -y ppa:fkrull/deadsnakes

RUN apt-get update \
    && apt-get -y install \
       wget python-pip \
       python2.6 python2.7 python3.2 python3.3 python3.4 \
       pypy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /install \
    && wget -O /install/pypy3-2.4-linux_x86_64-portable.tar.bz2 \
           "https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3-2.4-linux_x86_64-portable.tar.bz2" \
    && tar jxf /install/pypy3-*.tar.bz2 -C /install \
    && rm /install/pypy3-*.tar.bz2 \
    && ln -s /install/pypy3-*/bin/pypy3 /usr/local/bin/pypy3

RUN pip install tox

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN apt-get update && apt-get install -y -q unzip openjdk-7-jre-headless git

RUN mkdir /etc/service/go-agent
ADD install.sh /etc/service/go-agent/run

ADD http://download.go.cd/gocd-deb/go-agent-15.2.0-2248.deb /tmp/go-agent.deb

WORKDIR /tmp
RUN dpkg -i /tmp/go-agent.deb
RUN sed -i 's/DAEMON=Y/DAEMON=N/' /etc/default/go-agent

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]



