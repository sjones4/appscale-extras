FROM ubuntu:bionic

ENV FLASK_APP=appscale.cloud_storage \
    APPSCALE_CLOUD_STORAGE_SETTINGS=/opt/appscale-cloud-storage/acs.cfg \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get --assume-yes update \
 && apt-get --assume-yes --no-upgrade install awscli git openssl postgresql-client-10 python3-pip \
 && pip3 install git+https://github.com/sjones4/appscale-cloud-storage.git@topic-acs-aws \
 && apt-get --assume-yes remove git git-man krb5-locales openssh-client publicsuffix python3-pip xauth \
 && apt-get --assume-yes autoremove \
 && mkdir -pv /opt/appscale-cloud-storage \
 && apt-get --assume-yes clean all \
 && rm -rf /root/.cache \
 && rm -rf /var/lib/apt/lists/*

COPY ./ /opt/appscale-cloud-storage

WORKDIR /opt/appscale-cloud-storage

CMD /opt/appscale-cloud-storage/acs
