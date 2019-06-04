#!/bin/bash
# Generate service credentials for use with AppScale cloud storage

# Subject
SUB_COUNTRY_CODE="${1}"
SUB_STATE="${2}"
SUB_CITY="${3}"
SUB_CN="${4}"
SUB_EMAIL="${5}"

# Verify details
if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] || [ -z "${4}" ] || [ -z "${5}" ]; then
  echo "Usage: ${0} COUNTRY STATE CITY CN EMAIL"
  exit 1
fi

# Config
CLIENT_EMAIL="${CLIENT_EMAIL:-${SUB_EMAIL}}"
CLIENT_ID="${CLIENT_ID:-${CLIENT_EMAIL%%@*}}"
PROJECT_ID="${PROJECT_ID:-${CLIENT_ID}}"

# Generate certificate / key
openssl req \
  -x509 -newkey rsa:2048 -sha256 -nodes \
  -subj "/C=${SUB_COUNTRY_CODE}/ST=${SUB_STATE}/L=${SUB_CITY}/CN=${SUB_CN}/emailAddress=${SUB_EMAIL}" \
  -days 100000 -keyout "${CLIENT_ID}.key" -out "${CLIENT_ID}.crt"
# Json private key details
PRIVATE_KEY_ID=$(openssl pkcs8 -in "${CLIENT_ID}.key" -nocrypt -topk8 -outform DER | openssl sha1 | cut -d ' ' -f 2)
PRIVATE_KEY=$(sed -z 's/\n/\\n/g' "${CLIENT_ID}.key")

# Write credentials Json
cat>"${CLIENT_ID}.json"<<EOF
{
    "type": "service_account",
    "project_id": "${PROJECT_ID}",
    "private_key_id": "${PRIVATE_KEY_ID}",
    "private_key": "${PRIVATE_KEY}",
    "client_email": "${CLIENT_EMAIL}",
    "client_id": "${CLIENT_ID}"
}
EOF
echo "Generated ${CLIENT_ID}.json ${CLIENT_ID}.crt ${CLIENT_ID}.key"
