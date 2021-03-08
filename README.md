# SMA Conversion, in a self-contained docker container.
Run mdhiggins SMA within a docker container, with python pre-installed, using default options.

[Sickbeard_mp4_automator](https://github.com/mdhiggins/sickbeard_mp4_automator)

Usage:
`docker run --rm -v /media/folder/location:/data lildrunkensmurf/sma-docker:latest`

Docker image based on [jrottenberg/ffmpeg](https://hub.docker.com/r/jrottenberg/ffmpeg/) using the `snapshot-ubuntu` tag.
