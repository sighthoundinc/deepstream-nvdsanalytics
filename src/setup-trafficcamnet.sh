#!/bin/bash
set -e
if [ ! -f /data/cfg/model/*trafficcamnet*.etlt ]; then
    tmpdir=`mktemp -d`
    echo "No .etlt file found, setting up trafficcamnet"
    wget https://api.ngc.nvidia.com/v2/models/nvidia/tlt_trafficcamnet/versions/pruned_v1.0/zip \
        -O ${tmpdir}/tlt_trafficcamnet_pruned_v1.0.zip
    pushd ${tmpdir}
    unzip tlt_trafficcamnet_pruned_v1.0.zip
    # Not sure why this file has extension tlt and not etlt
    cp ${tmpdir}/resnet18_trafficcamnet_pruned.etlt /data/cfg/model/
    cp ${tmpdir}/trafficnet_int8.txt /data/cfg/model/
    cp ${tmpdir}/labels.txt /data/cfg/model/labels_trafficnet.txt
    popd
    rm -rf ${tmpdir}
fi
