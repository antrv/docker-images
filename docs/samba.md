# samba

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

See the [Samba and WS-Discovery Compose guide](samba-compose.md) for a complete deployment example.
