#!/bin/bash
pushd $(dirname $0)
pushd ..
# Did the run arguments specify a data mount?
echo $@ | grep ":/data"
if [ $? -ne 0 ]; then
    echo "No data directory specified, using default at data-default"
    echo "To override location for persistent data dir, pass a volume mount as"
    echo "argument to this script, for instance with "
    echo "  \"-v /path/to/datadir:/data\""
    mkdir -p data-default
    datamount="-v $(realpath data-default):/data"
fi
echo "Running docker with arguments ${datamount} $@"
docker run --net=host --runtime nvidia \
    ${datamount} \
    $@ \
   -it deepstream-nvdsanalytics-docker
