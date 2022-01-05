# librespot-docker

Docker images for [librespot's](https://github.com/librespot-org/librespot) Spotify client library.

**Features**
- _Multiple architectures supported_: linux/arm/v6, linux/arm/v7, linux/arm64 and linux/amd64.
- _Versioned images_: each librespot release gets built and a new image tag is added. Previous images are not deleted.
- _Minimal footprint_: uses balenalib alpine [base images](https://www.balena.io/docs/reference/base-images/base-images/) for lightweight images


__Note:__ These images were built to be used mainly with [balenaOS](https://www.balena.io/os) however they can be used with any other OS without problem. If further instructions are needed please [open an issue](https://github.com/tmigone/librespot-docker/issues/new).

## Usage

Images are built and published to [Docker Hub](https://hub.docker.com/r/tmigone/librespot). The following images are available:
- With alsa-backend: `tmigone/librespot:<version>`
- With pulseaudio-backend: `tmigone/librespot:<version>-pulseaudio`

For a detailed list of available tags visit: https://hub.docker.com/r/tmigone/librespot/tags

**docker-compose.yml**

```yaml
version: '2'

volumes:
  spotifycache:

services:

  spotify:
    image: tmigone/librespot:0.3.1
    privileged: true
    network_mode: host
    command: /usr/bin/librespot
    volumes:
      - spotifycache:/var/cache/raspotify
```

**Extend dockerfile**

```Dockerfile
FROM tmigone/librespot:0.3.1-pulseaudio
ENV PULSE_SERVER=tcp:localhost:4317

CMD [ "/usr/bin/librespot", "--name=spotiplayer" ]
```

**Options**

For more information about the available options, please refer to the [librespot documentation](https://github.com/librespot-org/librespot/wiki/Options).