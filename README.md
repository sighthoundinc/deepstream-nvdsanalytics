# bai-nvdsanalytics

Boulder AI customizations on top of the NVIDIA deepstream nvdsanalytics project.

See [Deepstream Documentation](https://docs.nvidia.com/metropolis/deepstream/dev-guide/index.html)
and [Gst-nvdsanalytics Documentation](https://docs.nvidia.com/metropolis/deepstream/dev-guide/text/DS_plugin_gst-nvdsanalytics.html)
for more details about the configuration and setup.

## Building

run `./docker/build.sh`

## Running

run `./docker/run.sh [docker options]` where `[docker options]` can optionally
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

Examples:
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
 currently peoplenet.  If a uff based model is present but no `.uff` file
 is present in the model directory at startup it will be populated with a default ssd coco
 model and label files (see [src/cfg-model-default](src/cfg-model-default) and
 the [src/generate-uff.sh](src/generate-uff.sh) script).

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

## Switching to SSD Model

By default this setup uses a Peoplenet TLT model.  To switch to SSD,
change the line referencing `config-file` in the `[primare-gie]` section of
the `bai_deepstream.txt` file to use 
`config-file=/data/cfg/deepstream/bai_config_infer_primary_ssd.txt`

## Updating SSD Model Files

You can replace the model file by copying the .pb file into the data directory
under the `model` subdir, replacing the existing .pb file there, and also
deleting the .uff file.  The .uff will get regenerated for the new model on
the next run.
