# bai-nvdsanalytics (master branch)

Boulder AI customizations on top of the NVIDIA deepstream nvdsanalytics project.

See [Deepstream Documentation](https://docs.nvidia.com/metropolis/deepstream/dev-guide/index.html)
and [Gst-nvdsanalytics Documentation](https://docs.nvidia.com/metropolis/deepstream/dev-guide/text/DS_plugin_gst-nvdsanalytics.html)
for more details about the configuration and setup.

**This `master` branch can be used to run inference on `.mp4` files on both Jetson and dGPU platforms. To run on a Boulder AI DNNCam using the image sensor (`baicamerasrc`) as the input source, please check out the [baicamerasrc](https://bitbucket.org/boulderai/deepstream-nvdsanalytics/src/baicamerasrc/) branch of this repository and follow the README there.**

--- 

## Building

Run `./docker/build.sh`

## Running

Run `./docker/run.sh [docker options]` where `[docker options]` can optionally
specify volume mounts to mount volumes inside the docker container with
`-v <path>:<container path>` where `path` represents the path outside
the container and `container path` represents the path inside the container.
Use these container paths:

 * `/data` for the working base directory (see /data/ structure below).  If
 not specified, this directory will be written to `data-default` in this
 working directory.

* `/input` for input files. Use `/input/video.mp4` for the input video used
 in the default configuration. If not specified, the container will provide
 its own sample video as input.

* `/output` for output files, where the container will write its output.
 If not specified, the output will be written to the `/data/output` directory
 inside the container and viewable wherever the `/data` container directory
 is mounted outside the container.
 A file "overlay.mp4" in this directory will contain the output video overlay.
 An output log will also be saved in this directory.

For more about docker volume mounts, see the [documentation on docker.com](https://docs.docker.com/storage/volumes/)

### Examples:
Run with default input video, writing output to `data-default`:

`./docker/run.sh`

Run with custom input video at `/tmp/my-test-video.mp4`
writing output to `data-default`:

`./docker/run.sh -v /tmp/my-test-video.mp4:/input/video.mp4`

Run with custom input video at `/tmp/my-test-video.mp4`
and write output to `/tmp/data-mytestdir`:

```
./docker/run.sh -v /tmp/my-test-video.mp4:/input/video.mp4 \
                -v /tmp/mytestdir-output:/output
```

### /data directory structure

The `/data/` directory structure will be created if necessary on first run and will
contain:

 * `/data/cfg/deepstream` containing deepstream configuration files.  If no
 files are present in this directory at startup they will be created from the
 defaults in [src/cfg-deepstream-default](src/cfg-deepstream-default).

 * `/data/cfg/model` containing model related files.  The default model is
 currently [peoplenet](https://ngc.nvidia.com/catalog/models/nvidia:tlt_peoplenet).
 This model is downloaded through the [src/setup-peoplenet.sh](src/setup-peoplenet.sh)
 script if it doesn't already exist.

### Viewing Output

By default, the overlay output will be written to `/output/overlay.mp4` which
will be available outside the container as described above.
To write RTSP instead, customize the deepstream configuration file to use the
RTSP output sink and then view based on configuration there, typically
`rtsp://<ip address>:8554/ds-test`

## Modifying Settings
You can access the content of the data-dir (default `data-default`) outside
the container.  This will be mapped to `/data` inside the container.  You can
use this to add files to the container, modify the deepstream configuration,
or update the model, then re-run as desired.

