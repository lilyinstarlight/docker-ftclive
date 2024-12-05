# _FIRST_ Tech Challenge Live Container Image

Container image for [_FIRST_ Tech Challenge Live](https://github.com/FIRST-Tech-Challenge/scorekeeper).

## Usage

Run the container image (with either `podman` or `docker`) with exposed port:

```sh
$ docker run -p 80:80 docker.io/lilyinstarlight/ftclive
```

Also optionally use volumes to preserve application data:

```sh
$ docker run -v "$PWD":/app/docs -p 80:80 docker.io/lilyinstarlight/ftclive
```
