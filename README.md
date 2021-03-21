[![Build status](https://github.com/renovatebot/docker-renovate-full/workflows/build/badge.svg)](https://github.com/renovatebot/docker-renovate-full/actions?query=workflow%3Abuild)
[![Docker Image Size](https://img.shields.io/docker/image-size/renovate/renovate/latest)](https://hub.docker.com/r/renovate/renovate)
[![Version](https://img.shields.io/docker/v/renovate/renovate/latest)](https://hub.docker.com/r/renovate/renovate)

# docker-renovate-full

This repository is the source for the Docker Hub image `renovate/renovate`.
Commits to the `main` branch are automatically built and published.
It will publish the `latest` and the versioned tags without suffix.
For the `slim` image see [here](https://github.com/renovatebot/docker-renovate).

## Usage

Read the [docs](https://docs.renovatebot.com/self-hosting) for more information on self-hosting Renovate with Docker.

### Samples

```sh
$ docker run --rm -it -v $PWD/config.js:/usr/src/app/config.js -e LOG_LEVEL=debug renovate/renovate --include-forks=true renovate-tests/gomod1
```

```sh
$ export RENOVATE_TOKEN=xxxxxxx
$ docker run --rm -it -e RENOVATE_TOKEN renovate/renovate renovate-tests/gomod1
```
