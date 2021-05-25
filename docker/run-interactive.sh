#!/bin/bash
pushd $(dirname $0)
pushd ..
basedir=`pwd`/src
docker run --net=host --runtime nvidia -v ${basedir}:${basedir} \
    -w ${basedir} \
    -it bai-deepstream /bin/bash

