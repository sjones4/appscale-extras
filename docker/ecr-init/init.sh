#!/bin/bash
# Load images to an ECR registry
set -euxo pipefail

# Use podman so we don't need a daemon
function docker() {
    podman --storage-driver=vfs "$@"
}

# Notify wait condition if requested
COND_STATUS="FAILURE"
COND_REASON="Registry not initialized"

if [ -n "${ECR_INIT_WAIT_COND_URL}" ] ; then
  function signal_wait_condition() {
    echo "Signaling wait condition ${ECR_INIT_WAIT_COND_URL} with ${COND_STATUS}"
    curl -s -X PUT -H 'Content-Type:' \
      --data-binary '{"Status": "'"${COND_STATUS}"'", "UniqueId": "initialized", "Data": "-", "Reason": "'"${COND_REASON}"'" }' \
      ${ECR_INIT_WAIT_COND_URL}
  }
  trap signal_wait_condition EXIT
fi

# ECR auth
echo "Getting ecr login"
ECR_INIT_LOGIN="$(aws ecr get-login --no-include-email)"
echo "Evaluating login"
eval ${ECR_INIT_LOGIN}

# ECR image load
for IMAGE_COUNT in  {1..1000}; do
  IMAGE_VAR="ECR_INIT_IMAGE_${IMAGE_COUNT}"
  IMAGE_NAME="${!IMAGE_VAR:-}"
  if [ -z "${IMAGE_NAME}" ] ; then
    break
  fi
  IMAGE_ECR="${ECR_INIT_PREFIX}/${IMAGE_NAME##*/}"
  echo "Processing image ${IMAGE_NAME} as ${IMAGE_ECR}"
  docker pull "${IMAGE_NAME}"
  docker tag  "${IMAGE_NAME}" "${IMAGE_ECR}"
  docker push "${IMAGE_ECR}"
done

COND_STATUS="SUCCESS"
COND_REASON="Registry initialized"

