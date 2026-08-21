# searxng

Privacy-respecting metasearch engine — StatefulSet with a single persistent volume and node scheduling support for node-local storage.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/searxng
```

## Introduction

This chart deploys [SearXNG](https://docs.searxng.org/), a free internet metasearch engine that aggregates results from other search services without tracking users.

Unlike the community chart (a Deployment with two separate PVCs), this chart runs SearXNG as a **StatefulSet with a single `data` volume**. Both `/etc/searxng` (config) and `/var/cache/searxng` (cache) live on the same volume as subdirectories, which keeps all persistent state together and gives the pod a stable identity.

Because the default StorageClass is node-local (`local-path`), the chart supports `nodeSelector`, `tolerations` and `affinity` so the pod can be pinned to the node that owns the storage.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+
- A `local-path` (or any ReadWriteOnce) StorageClass

## Installing the Chart

```bash
helm install searxng lbenicio-community/searxng \
  --namespace default \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=search.example.com
```

## Pin to the storage node

With node-local storage the volume lives on one node. Pin the pod there:

```yaml
nodeSelector:
  kubernetes.io/hostname: k8s-node-3

# or prefer, but don't require, the storage node
affinity:
  nodeAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        preference:
          matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
                - k8s-node-3
```

## Parameters

### Core

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `searxng/searxng` | Container image |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `replicaCount` | int | `1` | Number of replicas (one PVC each) |

### SearXNG config

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `config.settings` | object | defaults | `settings.yml` content rendered into a ConfigMap |
| `secret.existingSecret` | string | `""` | Existing Secret with `SEARXNG_SECRET` |
| `secret.value` | string | `""` | Explicit secret value (random otherwise) |
| `env` | object | `{}` | Environment variables (e.g. `SEARXNG_PORT`) |

### Persistence

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `persistence.enabled` | bool | `true` | Enable PVC via volumeClaimTemplates |
| `persistence.existingClaim` | string | `""` | Use an existing PVC |
| `persistence.storageClass` | string | `local-path` | StorageClass |
| `persistence.size` | string | `3Gi` | PVC size (holds config + cache) |
| `persistence.retainOnDelete` | bool | `true` | Keep PVCs when deleting the StatefulSet |
| `initResources` | object | small | Resources for the init container (runs as root to chown the volume) |

### Network

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `8080` | HTTP port |
| `ingress.enabled` | bool | `false` | Enable Ingress |
| `ingress.className` | string | `""` | Ingress class name |

### Scheduling

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `nodeSelector` | object | `{}` | Pin the pod to a node |
| `tolerations` | list | `[]` | Tolerations |
| `affinity` | object | `{}` | Affinity rules |

### Monitoring

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `keel.enabled` | bool | `true` | Keel auto-update annotations |
| `serviceMonitor.enabled` | bool | `false` | Prometheus Operator ServiceMonitor |

## How config works

`config.settings` is rendered into a ConfigMap. An init container copies
`settings.yml` into the `config` subdirectory of the data volume and fixes
ownership to the `searxng` user (uid/gid 977). Changing the ConfigMap content
updates the pod annotation checksum and rolls the StatefulSet, and the new
`settings.yml` is copied over the volume's copy on the next start.

## License

This chart is licensed under GPL-3.0. SearXNG is licensed under AGPL-3.0.
