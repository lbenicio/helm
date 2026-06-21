# timemachine

Samba-based Time Machine backup server for macOS — persistent, scalable, with Traefik TCP routing.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/timemachine
```

## Introduction

This chart deploys [mbentley/timemachine](https://github.com/mbentley/docker-timemachine), a Docker container that runs Samba configured as a Time Machine target. Each replica gets its own persistent volume, making it suitable for backing up multiple Macs. The chart supports Traefik IngressRouteTCP for exposing SMB over the network, and integrates with Keel for automatic image updates.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+
- A Secret with credentials (`TM_USERNAME` and `PASSWORD` keys) or `credentials.createSecret: true`

## Installing the Chart

```bash
# First, create a credentials secret
kubectl create secret generic credentials \
  --from-literal=TM_USERNAME=myuser \
  --from-literal=PASSWORD=mypassword

# Then install
helm install timemachine lbenicio-community/timemachine \
  --namespace default \
  --set replicaCount=3 \
  --set persistence.size=200Gi
```

## Parameters

### Core

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `mbentley/timemachine` | Container image |
| `image.tag` | string | `""` | Image tag |
| `replicaCount` | int | `1` | Number of replicas (one PVC each) |

### Time Machine

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `timemachine.shareName` | string | `""` | Samba share name (defaults to pod name) |
| `timemachine.volumeSizeLimit` | int | `0` | Volume size limit in MB (0 = unlimited) |
| `timemachine.setPermissions` | bool | `true` | Set permissions on startup |

### Credentials

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `credentials.createSecret` | bool | `false` | Create a Secret with credentials |
| `credentials.existingSecret` | string | `credentials` | Name of existing Secret |
| `credentials.usernameKey` | string | `TM_USERNAME` | Secret key for username |
| `credentials.passwordKey` | string | `PASSWORD` | Secret key for password |

### Persistence

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `persistence.enabled` | bool | `true` | Enable PVC via volumeClaimTemplates |
| `persistence.existingClaim` | string | `""` | Use existing PVC |
| `persistence.storageClass` | string | `local-path` | StorageClass |
| `persistence.size` | string | `100Gi` | PVC size per replica |
| `persistence.retainOnDelete` | bool | `true` | Keep PVCs when deleting StatefulSet |

### Network

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `service.type` | string | `ClusterIP` | Service type |
| `service.smbPort` | int | `445` | SMB port |
| `ingressRouteTCP.enabled` | bool | `false` | Traefik IngressRouteTCP |
| `ingressRouteTCP.entryPoints` | list | `[smb]` | Traefik entrypoints |

### Monitoring

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `keel.enabled` | bool | `true` | Keel auto-update |
| `podAnnotations` | object | `{}` | Prometheus scrape annotations |
| `serviceMonitor.enabled` | bool | `false` | Prometheus ServiceMonitor |

## Traefik IngressRouteTCP

Expose Samba externally via Traefik TCP routing:

```yaml
ingressRouteTCP:
  enabled: true
  entryPoints:
    - smb
  routes:
    - match: HostSNI(`*`)
      services:
        - name: timemachine
          port: 445
```

## Multiple Backups

Each replica provisions its own PVC and gets a unique share name (pod name). Scale up to add more backup targets:

```bash
helm upgrade timemachine lbenicio-community/timemachine \
  --set replicaCount=3
```

This creates `timemachine-0`, `timemachine-1`, `timemachine-2` each with their own 100Gi PVC and share name matching the pod name.

## License

This chart is licensed under GPL-3.0. The timemachine Docker image is maintained by [mbentley](https://github.com/mbentley/docker-timemachine).
