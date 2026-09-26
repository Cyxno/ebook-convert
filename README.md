# ebook-convert

Minimal container image containing the official Calibre `ebook-convert` CLI, built for the EPUB validation/conversion layer in the books stack.

## Current release

- Calibre: **9.15.0**
- Base: Debian Bookworm Slim, digest-pinned
- Architecture: **linux/amd64**
- Runtime user: UID 1000 (`converter`)
- No daemon, GUI, VNC or web server
- Intended runtime: ephemeral, ideally with `--network none`

The Calibre binary bundle is downloaded from the official Calibre distribution server and verified during the build with SHA-256:

```
3f5301c0aa51e5fb2d5f6dcd04024ba4e86501ab328ce5d9d6760efccb887990
```

## Usage

```bash
docker run --rm \
  --network none \
  -v /path/to/input:/input:ro \
  -v /path/to/output:/output \
  ghcr.io/cyxno/ebook-convert:1.0.0 \
  /input/book.epub /output/book.epub
```

The writable output directory must be writable by UID 1000.

## Build locally

```bash
docker build --pull=false -t ghcr.io/cyxno/ebook-convert:1.0.0 .
docker run --rm ghcr.io/cyxno/ebook-convert:1.0.0 --version
```

## Publishing

GitHub Actions publishes the image to GHCR using the repository-scoped `GITHUB_TOKEN`; no personal access token is stored in this repository.

Release 1.0.0 publishes:

- `ghcr.io/cyxno/ebook-convert:1.0.0`
- `ghcr.io/cyxno/ebook-convert:1.0`
- `ghcr.io/cyxno/ebook-convert:latest`

Production should pin the resulting registry digest rather than relying on a mutable tag.

## Scope

This image deliberately contains only the Calibre runtime and the small set of Debian runtime libraries needed for `ebook-convert`. It is not intended to run Calibre's desktop UI, content server, library manager or VNC stack.


## Release

Current container release: **1.0.0**.
