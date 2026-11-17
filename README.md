# Docker Images

This repository contains my custom docker images.

## Images

### iventoy

PXE server for network booting ISO images.

```
docker pull ghcr.io/antrv/iventoy:1.0.50
```

No environment variables — configured entirely through the web UI on port `26000`. Mount `/opt/iventoy/iso` as a volume to provide ISO images.

---

### minidlna

UPnP/DLNA media server that streams media files to devices on the local network.

```
docker pull ghcr.io/antrv/minidlna:latest
```

| Variable | Default | Description |
|---|---|---|
| `FRIENDLY_NAME` | `Media Server` | Server name announced on the network |
| `PUID` | `1000` | UID the daemon runs as |
| `PGID` | `100` | GID the daemon runs as |

Mount media directories under `/opt` as volumes. Exposes port `1900/udp` (SSDP discovery) and `8200/tcp` (HTTP media streaming).

---

### samba

SMB file server. Supports multiple users and shared directories, all configurable via environment variables.

[Documentation](docs/samba.md)

---

### softethervpn

SoftEther VPN server compiled from source.

```
docker pull ghcr.io/antrv/softethervpn:4.44
```

| Variable | Default | Description |
|---|---|---|
| `VPN_INTERFACES` | — | Comma-separated `iface,addr/prefix` pairs to configure after startup (e.g. `tap_vpn,10.0.0.1/24`). Multiple pairs are listed in sequence: `iface1,addr1,iface2,addr2,…` |

Config files (`vpn_server.config`, `vpn_client.config`, `vpn_bridge.config`) are loaded from `VPN_CONFIG_DIR` (`/etc/softethervpn`) on start and saved back on shutdown. Mount that directory as a volume to persist configuration.

---

### wsdd2

WS-Discovery daemon that makes the Samba server visible in Windows network neighborhood.

```
docker pull ghcr.io/antrv/wsdd2:latest
```

| Variable | Default | Description |
|---|---|---|
| `MACHINENAME` | `SERVER` | Machine name announced on the network |
| `WORKGROUP` | `WORKGROUP` | Workgroup name |

See the [Samba and WS-Discovery Compose guide](docs/samba-compose.md) for a complete deployment example.

---

## Examples

The `examples/` directory contains Docker Compose file examples for running the images.

See the [Samba and WS-Discovery Compose guide](docs/samba-compose.md) for a complete file server setup.

---

## Image Metadata

Per-image build behaviour is controlled via `ARG` defaults in each `Dockerfile`:

- **`ARG IMAGE_TAG=<version>`** — sets the published image tag and is passed as a build argument. Defaults to `latest` if absent.
- **`ARG IMAGE_PLATFORMS=<platforms>`** — comma-separated list of target platforms (e.g. `linux/amd64,linux/arm64`). Defaults to `linux/amd64,linux/arm64` if absent.
