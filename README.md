# Docker Images

This repository contains my custom docker images.

## Images

- **samba** — SMB file server. Supports multiple users and shared directories, all configurable via environment variables.
  ```
  docker pull ghcr.io/antrv/samba:latest
  ```

- **wsdd2** — WS-Discovery daemon that makes the Samba server visible in Windows network neighborhood.
  ```
  docker pull ghcr.io/antrv/wsdd2:latest
  ```

- **softethervpn** — SoftEther VPN server compiled from source.
  ```
  docker pull ghcr.io/antrv/softethervpn:4.44
  ```

- **iventoy** — PXE server for network booting ISO images.
  ```
  docker pull ghcr.io/antrv/iventoy:1.0.25
  ```

## Image Metadata

Per-image build behaviour is controlled via `ARG` defaults in each `Dockerfile`:

- **`ARG IMAGE_TAG=<version>`** — sets the published image tag and is passed as a build argument. Defaults to `latest` if absent.
- **`ARG IMAGE_PLATFORMS=<platforms>`** — comma-separated list of target platforms (e.g. `linux/amd64,linux/arm64`). Defaults to `linux/amd64,linux/arm64` if absent.
