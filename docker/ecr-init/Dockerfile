FROM ubuntu:bionic

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get --assume-yes update \
 && apt-get --assume-yes install software-properties-common \
 && add-apt-repository -y ppa:projectatomic/ppa \
 && apt-get --assume-yes install iptables awscli curl podman \
 && apt-get --assume-yes clean all \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY init.sh /root/init.sh

CMD /root/init.sh
