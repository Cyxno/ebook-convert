# ebook-convert — minimale converter-image

Headless `ebook-convert` (Calibre CLI) voor de books-stack EPUB-validator.
Geen GUI, geen VNC, geen webserver, geen Calibre-server — alleen de CLI.

- Base: `debian:bookworm-slim` (gepind op digest)
- Calibre: officiële binary-bundle `calibre-9.15.0-x86_64.txz` van
  `download.calibre-ebook.com`, sha256 geverifieerd tijdens de build
  (`3f5301c0aa51e5fb2d5f6dcd04024ba4e86501ab328ce5d9d6760efccb887990`)
- Non-root (uid 1000), geen netwerk nodig tijdens conversie (`--network none`)
- ~970 MB (tegenover 3,57 GB van het LSIO-calibre-desktopimage)

## Build

```sh
cd /mnt/user/appdata/books-stack/tools/ebook-convert
./build.sh 1.0.0
```

## Gebruik

```sh
docker run --rm --network none \
  -v /input:/input:ro -v /output:/output \
  ghcr.io/cyxno/ebook-convert:1.0.0 \
  /input/book.epub /output/book.epub
```

## Push naar GHCR + finaliseren

Auth bestaat nog niet op de Unraid-host. Eenmalig (met een GitHub-PAT met
`read:packages` + `write:packages`, nooit in dit bestand opslaan):

```sh
echo <PAT> | docker login ghcr.io -u cyxno --password-stdin
```

Daarna de gehele afronding automatisch (pull, registry-digest, smoke/regressietest,
digest-pin validator, integratietest):

```sh
bash "/boot/config/plugins/user.scripts/scripts/Books-stack ghcr finalize/script"
```

Log: `/mnt/user/appdata/books-stack/logs/ghcr-finalize.log`

Huidig lokaal image-id: `sha256:e3959a452a6d8c2759d4249facd58c76c861e64bc677a783ab42e400582d8cf7`
(let op: dit is de **config-digest van de lokale build**, niet de registry manifest-digest;
die laatste verschijnt pas na push/pull als `RepoDigests`-vermelding).

## Updaten naar een nieuwe Calibre-versie

1. Nieuwe `CALIBRE_VERSION` + `CALIBRE_TXZ_SHA256` in de Dockerfile (sha256 zelf
   berekenen na download van het officiële txz-bestand).
2. `./build.sh <nieuwe-versie>`, functioneel testen, pas daarna de validator
   (`Books-stack epub validator`) op het nieuwe image/digest zetten.
