#!/usr/bin/env bash
set -euo pipefail

IMAGE="${IMAGE:-ghcr.io/cyxno/ebook-convert:1.0.0}"

docker build --pull=false -t "$IMAGE" .
docker run --rm "$IMAGE" --version
docker image inspect "$IMAGE" --format '{{.Id}} {{.Size}}'
