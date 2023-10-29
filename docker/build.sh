#!/bin/bash
pushd $(dirname $0)
pushd ..
dockerfile=docker/Dockerfile.dGPU
uname -m | grep aarch64 > /dev/null
if [ $? -eq 0 ]; then
    dockerfile=docker/Dockerfile.Jetson
fi
docker build -t deepstream-nvdsanalytics-docker -f ${dockerfile} src
