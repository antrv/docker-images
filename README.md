# Docker Images

This repository contains my custom docker images.

## Images

### iventoy

PXE server for network booting ISO images.

```
docker pull ghcr.io/antrv/iventoy:1.0.25
```

No environment variables — configured entirely through the web UI on port `26000`. Mount `/opt/iventoy/iso` as a volume to provide ISO images.

---

### samba

SMB file server. Supports multiple users and shared directories, all configurable via environment variables.

```
docker pull ghcr.io/antrv/samba:latest
```

**Server**

| Variable | Default | Description |
|---|---|---|
| `WORKGROUP` | `HOME` | Workgroup name |
| `MACHINENAME` | `FILES` | NetBIOS name |
| `MACHINETITLE` | `File Server` | Server description string |

**Users** (repeat for N = 1, 2, 3, …)

| Variable | Default | Description |
|---|---|---|
| `USER{N}_NAME` | — | Username |
| `USER{N}_UID` | — | UID (optional) |
| `USER{N}_PASSWORD` | — | Password |
| `USER{N}_PASSWORD_FILE` | — | Path to a file containing the password (alternative to `USER{N}_PASSWORD`) |

**Shares** (repeat for N = 1, 2, 3, …)

| Variable | Default | Description |
|---|---|---|
| `SHARE{N}_NAME` | — | Share name |
| `SHARE{N}_PATH` | — | Path inside the container |
| `SHARE{N}_COMMENT` | share name | Description shown to clients |
| `SHARE{N}_BROWSEABLE` | `yes` | Whether the share is visible when browsing |
| `SHARE{N}_READ_ONLY` | `yes` | Set to `no` to allow writes for all users |
| `SHARE{N}_WRITE_LIST` | `@users` | Users or groups with write access |

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

---

## Image Metadata

Per-image build behaviour is controlled via `ARG` defaults in each `Dockerfile`:

- **`ARG IMAGE_TAG=<version>`** — sets the published image tag and is passed as a build argument. Defaults to `latest` if absent.
- **`ARG IMAGE_PLATFORMS=<platforms>`** — comma-separated list of target platforms (e.g. `linux/amd64,linux/arm64`). Defaults to `linux/amd64,linux/arm64` if absent.
