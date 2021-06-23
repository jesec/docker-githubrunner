## Minimal Github Actions self-hosted runner with Docker

### Usage

**Compose**

Required arguments: `RUNNER_TOKEN`, `RUNNER_URL`

Optional arguments: `RUNNER_ARCH`, `RUNNER_VERSION`

```sh
# Compose "runner" image
$ docker buildx build --build-arg RUNNER_TOKEN=xxx --build-arg RUNNER_URL=xxx --load --tag runner .
```

**Run**

```sh
$ docker run -d --rm --init -v /var/run/docker.sock:/var/run/docker-host.sock --name runner runner
```

### License

0BSD or Public Domain
