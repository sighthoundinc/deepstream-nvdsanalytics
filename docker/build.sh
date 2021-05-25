#!/bin/bash
pushd $(dirname $0)
pushd ..
dockerfile=docker/Dockerfile.dGPU
uname -m | grep aarch64 > /dev/null
if [ $? -eq 0 ]; then
    dockerfile=docker/Dockerfile.Jetson
    set -e
    echo "authenticating to gcr using json key at /data/external-bai-*"
    cat /data/keys/external-bai-*.json | docker login -u _json_key --password-stdin https://gcr.io
fi
docker build -t bai-deepstream -f ${dockerfile} src
