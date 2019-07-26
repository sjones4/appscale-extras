FROM python:2.7-stretch AS build-env

RUN mkdir -pv /appscale/site-packages \
 && mkdir -pv /appscale/appscale \
 && apt-get --assume-yes update \
 && apt-get --assume-yes install swig \
 && cd /root \
 && wget --no-verbose https://www.foundationdb.org/downloads/6.1.8/ubuntu/installers/foundationdb-clients_6.1.8-1_amd64.deb \
 && dpkg --install foundationdb-clients_6.1.8-1_amd64.deb \
 && git clone --quiet https://github.com/sjones4/appscale.git \
 && cd /root/appscale \
 && git checkout ebe8bb1eb9c3e927ac143cec477a575cc57c2e8c \
 && pip install --target /appscale/site-packages ./common ./AppDB foundationdb==6.1.8 \
 && cp -rp AppServer/google /appscale/site-packages/ \
 && touch /appscale/site-packages/appscale/__init__.py


FROM python:2.7-slim-stretch

ENV HOME=/appscale \
    APPSCALE_HOME=/appscale \
    PYTHONPATH=/appscale/site-packages \
    PATH=$PATH:$PYTHONPATH/bin

COPY --from=build-env /appscale/site-packages /appscale/site-packages
COPY --from=build-env /usr/lib/libfdb_c.so /usr/lib/libfdb_c.so

WORKDIR /appscale

CMD ["appscale-datastore", "--type", "fdb", "--port", "4000"]

