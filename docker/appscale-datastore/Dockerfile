FROM python:2.7-stretch AS build-env

RUN mkdir -pv /appscale/site-packages \
 && mkdir -pv /appscale/appscale \
 && apt-get --assume-yes update \
 && apt-get --assume-yes install swig \
 && cd /root \
 && wget --no-verbose https://www.foundationdb.org/downloads/6.1.8/ubuntu/installers/foundationdb-clients_6.1.8-1_amd64.deb \
 && dpkg --install foundationdb-clients_6.1.8-1_amd64.deb \
 && git clone --quiet https://github.com/appscale/appscale.git \
 && cd /root/appscale \
 && git checkout e9c6b8693eb388b5652cef481351306533a494fa \
 && pip install --target /appscale/site-packages ./common ./AppDB foundationdb==6.1.8 \
 && cp -rp AppServer/google /appscale/site-packages/ \
 && touch /appscale/site-packages/appscale/__init__.py


FROM python:2.7-slim-stretch

ENV HOME=/appscale \
    APPSCALE_HOME=/appscale \
    PYTHONPATH=/appscale/site-packages

COPY --from=build-env /appscale/site-packages /appscale/site-packages
COPY --from=build-env /usr/lib/libfdb_c.so /usr/lib/libfdb_c.so

WORKDIR /appscale

CMD ["/appscale/site-packages/bin/appscale-datastore", "--type", "fdb", "--port", "4000"]

