# Environment for Google Cloud Platform service clients

Client runtime environment for use with Google Cloud Platform reverse
proxy.

Run clients in this container to direct GCP service calls to their
AppScale alternatives.

```
docker run --rm -it \
  --add-host=accounts.google.com:10.10.9.168 \
  --add-host=batch-datastore.googleapis.com:10.10.9.168 \
  --add-host=datastore.googleapis.com:10.10.9.168 \
  --add-host=storage.googleapis.com:10.10.9.168 \
  --add-host=www.googleapis.com:10.10.9.168 \
  -v $(pwd):/work -w /work appscale-gcp-client-runtime /bin/bash
```
