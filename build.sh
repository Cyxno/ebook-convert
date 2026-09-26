#!/bin/bash
# Bouwt en pinned de minimale ebook-convert image.
# Gebruik: ./build.sh [versie-tag]   (default 1.0.0)
set -euo pipefail
cd "$(dirname "$0")"

VERSION="${1:-1.0.0}"
IMAGE="ebook-convert"

docker build -t "${IMAGE}:${VERSION}" .
docker tag "${IMAGE}:${VERSION}" "${IMAGE}:${VERSION%.*}" 2>/dev/null || true

DIGEST=$(docker image inspect "${IMAGE}:${VERSION}" --format '{{index .RepoDigests 0}}' 2>/dev/null || true)
ID=$(docker image inspect "${IMAGE}:${VERSION}" --format '{{.Id}}')
echo
echo "built: ${IMAGE}:${VERSION}"
echo "image id : ${ID}"
echo "repodigest: ${DIGEST:-(nog niet gepusht; digest ontstaat bij push)}"
echo
echo "Push naar GHCR (eenmalig auth nodig):"
echo "  docker tag ${IMAGE}:${VERSION} ghcr.io/cyxno/ebook-convert:${VERSION}"
echo "  docker push ghcr.io/cyxno/ebook-convert:${VERSION}"
