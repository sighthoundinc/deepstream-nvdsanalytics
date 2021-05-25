#!/bin/bash
set -e
tmpdir=`mktemp -d`
if [ ! -f /data/cfg/model/*.etlt ]; then
    echo "No .etlt file found, setting up peoplenet"
    wget --content-disposition https://api.ngc.nvidia.com/v2/models/nvidia/tlt_peoplenet/versions/pruned_v2.0/zip \
        -O ${tmpdir}/tlt_peoplenet_pruned_v2.0.zip
    pushd ${tmpdir}
    unzip tlt_peoplenet_pruned_v2.0.zip
    cp ${tmpdir}/resnet34_peoplenet_pruned.etlt /data/cfg/model/
    cp ${tmpdir}/labels.txt /data/cfg/model/
    popd
    rm -rf ${tmpdir}
fi
