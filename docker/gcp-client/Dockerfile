FROM ubuntu:bionic

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN apt-get --assume-yes update \
 && apt-get --assume-yes install openjdk-8-jdk-headless wget \
 && apt-get --assume-yes clean all

RUN mkdir -pv /usr/local/share/ca-certificates/googleapis \
 && mkdir -pv /tmp/classes/com/google/api/client/googleapis \
 && wget https://raw.githubusercontent.com/sjones4/appscale-extras/master/docker/gcp-proxy/googleapis.crt -O /usr/local/share/ca-certificates/googleapis/googleapis.crt \
 && wget https://raw.githubusercontent.com/googleapis/google-api-java-client/master/google-api-client/src/main/resources/com/google/api/client/googleapis/google.jks -O /tmp/classes/com/google/api/client/googleapis/google.jks \
 && update-ca-certificates \
 && keytool -import -noprompt -storepass notasecret -alias googleapis -file /usr/local/share/ca-certificates/googleapis/googleapis.crt -keystore /tmp/classes/com/google/api/client/googleapis/google.jks \
 && jar cf /tmp/appscale-gcp-client-trust.jar -C /tmp/classes/ . \
 && rm -rvf /tmp/classes \
 && mv /tmp/appscale-gcp-client-trust.jar /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/


