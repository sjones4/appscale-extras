# Reverse proxy for Google Cloud Platform services

Docker compose configuration for Google Cloud Platform reverse proxy.

Provides TLS termination so GCP clients can be used unaltered with:

* AppScale Cloud Storage
* AppScale Cloud Datastore Proxy

Certificates are generated using OpenSSL v1.1.1+:

```
openssl req -x509 -newkey rsa:2048 -sha256 -nodes -days 36500 \
  -keyout googleapis.key \
  -out googleapis.crt \
  -subj '/C=US/ST=California/L=Santa Barbara/O=AppScale Systems/CN=localhost' \
  -addext 'subjectAltName=DNS:*.googleapis.com,DNS:*.google.com' \
  -addext 'keyUsage=critical,digitalSignature,keyEncipherment'
```

