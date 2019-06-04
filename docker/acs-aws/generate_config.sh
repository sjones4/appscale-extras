#!/bin/bash
# Generate configuration for use with AppScale cloud storage
CREDS_DIR="/var/lib/appscale/service-credentials"

# Check environment
: ${APPSCALE_CLOUD_STORAGE_ACCESS_KEY:?Access key is required}
: ${APPSCALE_CLOUD_STORAGE_SECRET_KEY:?Secret key is required}
: ${APPSCALE_CLOUD_STORAGE_REGION:?Region is required}

# Defaults
APPSCALE_CLOUD_STORAGE_S3_HOST=${APPSCALE_CLOUD_STORAGE_S3_HOST:-"s3.${APPSCALE_CLOUD_STORAGE_REGION}.amazonaws.com"}
APPSCALE_CLOUD_STORAGE_S3_PORT=${APPSCALE_CLOUD_STORAGE_S3_PORT:-443}
APPSCALE_CLOUD_STORAGE_S3_USE_SSL=${APPSCALE_CLOUD_STORAGE_S3_USE_SSL:-True}

# Write configuration
cat>"acs.cfg"<<EOF
# S3 backend administrative credentials
S3_ADMIN_CREDS = {
    'access_key': '${APPSCALE_CLOUD_STORAGE_ACCESS_KEY}',
    'secret_key': '${APPSCALE_CLOUD_STORAGE_SECRET_KEY}'
}
# S3 backend endpoint
S3_HOST = '${APPSCALE_CLOUD_STORAGE_S3_HOST}'
S3_PORT = ${APPSCALE_CLOUD_STORAGE_S3_PORT}
S3_USE_SSL = ${APPSCALE_CLOUD_STORAGE_S3_USE_SSL}
# Postgres for storing bucket metadata and session state
POSTGRES_DB = {
    'host': '${APPSCALE_CLOUD_STORAGE_DB_HOST:-postgres}',
    'dbname': '${APPSCALE_CLOUD_STORAGE_DB_NAME:-postgres}',
    'user': '${APPSCALE_CLOUD_STORAGE_DB_USER:-postgres}',
    'password': '${APPSCALE_CLOUD_STORAGE_DB_PASS:-changeme}'
}
# User accounts authorized to use AppScale Cloud Storage.
USERS = {
EOF
for CRT_FILE in "${CREDS_DIR}"/*.crt; do
cat>>"acs.cfg"<<EOF
    '${CRT_FILE:${#CREDS_DIR}+1: -4}@appscale.internal': {
        'certificate': '${CRT_FILE}',
        'aws_access_key': '${APPSCALE_CLOUD_STORAGE_ACCESS_KEY}',
        'aws_secret_key': '${APPSCALE_CLOUD_STORAGE_SECRET_KEY}'
    }
EOF
done
cat>>"acs.cfg"<<EOF
}
# Set a name for subdomain handling
SERVER_NAME = 'storage'
EOF
