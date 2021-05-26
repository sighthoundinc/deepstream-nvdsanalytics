# bai-nvdsanalytics (baicamerasrc)

Boulder AI customizations on top of the NVIDIA deepstream nvdsanalytics project.

See [Deepstream Documentation](https://docs.nvidia.com/metropolis/deepstream/dev-guide/index.html)
and [Gst-nvdsanalytics Documentation](https://docs.nvidia.com/metropolis/deepstream/dev-guide/text/DS_plugin_gst-nvdsanalytics.html)
for more details about the configuration and setup.

## Building

Run `./docker/build.sh`

## Running with Image Sensor input (baicamerasrc)

Run `./docker/run.sh [docker options]` where `[docker options]` can optionally
specify volume mounts to mount volumes inside the docker container with
`-v <path>:<container path>` where `path` represents the path outside
the container and `container path` represents the path inside the container.  
You can use the `/data` container path to use configs other than the default.

 * `/data` for the working base directory (see /data/ structure below).  If
 not specified, this directory will be written to `data-default` in this
 working directory.

For more about docker volume mounts, see the [documentation on docker.com](https://docs.docker.com/storage/volumes/)

Examples:  
Run with default model ([peoplenet](https://ngc.nvidia.com/catalog/models/nvidia:tlt_peoplenet)):  
`./docker/run.sh`

Run with traffic model ([trafficamnet](https://ngc.nvidia.com/catalog/models/nvidia:tlt_trafficcamnet)):  
```
mkdir -p data-demo/cfg/model
cp -r src/cfg-deepstream-trafficcamnet/ data-demo/cfg/deepstream
./docker/run.sh -v $(realpath data-demo):/data/
```


## /data directory structure

The `/data/` directory structure will be created if necessary on first run and will
contain:

 * `/data/cfg/deepstream` containing deepstream configuration files.  If no
 files are present in this directory at startup they will be created from the
 defaults in [src/cfg-deepstream-default](src/cfg-deepstream-default).

 * `/data/cfg/model` containing model related files.  The default model is
 currently [peoplenet](https://ngc.nvidia.com/catalog/models/nvidia:tlt_peoplenet).
 This model is downloaded through the [src/setup-peoplenet.sh](src/setup-peoplenet.sh)
 script if it doesn't already exist.

## Viewing Output

By default, the overlay output will be written to the RTSP output sink and can be viewed at
`rtsp://<ip address>:8554/ds-test`.

## Modifying Settings
You can access the content of the data-dir (default `data-default`) outside
the container.  This will be mapped to `/data` inside the container.  You can
use this to add files to the container, modify the deepstream configuration,
or update the model, then re-run as desired.

