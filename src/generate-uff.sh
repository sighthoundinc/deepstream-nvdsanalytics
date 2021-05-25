#!/bin/bash
set -e
modeldir=/data/cfg/model
if [ ! -e ${modeldir}/bai_ssd_model_trt.uff ]; then
    echo "uff file missing for model, generating"
    mkdir -p ${modeldir}
    tmpdir=$(mktemp -d)
    if [ ! -e ${modeldir}/bai_ssd_model_trt.pb ]; then
        model_basename=ssd_inception_v2_coco_2017_11_17
        echo "Missing ${modeldir}/bai_ssd_model_trt.pb, using ${model_basename}"
        echo "Please delete the .uff file and add a custom bai_ssd_model_trt.pb to use a custom model"
        pushd ${tmpdir}
        wget http://download.tensorflow.org/models/object_detection/${model_basename}.tar.gz
        tar -xvf ${model_basename}.tar.gz
        cp ${tmpdir}/${model_basename}/frozen_inference_graph.pb ${modeldir}/bai_ssd_model_trt.pb
    fi
    pushd ${tmpdir}
    python3 /usr/lib/python3.6/dist-packages/uff/bin/convert_to_uff.py \
       ${modeldir}/bai_ssd_model_trt.pb  -O NMS \
       -p /usr/src/tensorrt/samples/sampleUffSSD/config.py \
       -o ${modeldir}/bai_ssd_model_trt.uff
    rm -rf ${tmpdir}
fi
