#!/bin/bash
# Configuration for management of AppScale deployments on Ubuntu
set -eu

REL_DIR="${1:-.}"
BASE_DIR=$(readlink -f "${REL_DIR}")

PACKAGES="
git
python
python-pip
python-virtualenv
"

DIRECTORIES="
deployments
repos
venvs
"

function log() {
  echo "$(date --iso-8601=seconds) ${1}"
}

if [ "${REL_DIR}" == "${BASE_DIR}" ] ; then
  log "Using directory ${REL_DIR}"
else
  log "Using directory ${REL_DIR} [${BASE_DIR}]"
fi

log "Installing required packages"
apt-get update
apt-get --assume-yes install ${PACKAGES}

log "Creating deployment directories"
for DIRECTORY in ${DIRECTORIES}; do
  if [ ! -d "${BASE_DIR}/${DIRECTORY}" ] ; then
    mkdir --parents --verbose "${BASE_DIR}/${DIRECTORY}"
  fi
done

log "Cloning GIT repositories"
pushd "${BASE_DIR}/repos"
  if [ ! -d "appscale" ] ; then
    git clone "https://github.com/AppScale/appscale.git" "appscale"
  fi
  if [ ! -d "appscale-tools" ] ; then
    git clone -- "https://github.com/AppScale/appscale-tools.git" "appscale-tools"
  fi
popd

log "Creating virtual environments"
pushd "${BASE_DIR}/venvs"
  if [ ! -d "appscale-tools" ] ; then
    virtualenv "appscale-tools"
    set +u; source "appscale-tools/bin/activate"; set -u
    pip install --upgrade "${BASE_DIR}/repos/appscale-tools/"
    set +u; deactivate; set -u
  fi
popd

log "Configuration complete"
