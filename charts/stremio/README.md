# stremio

Stremio media server, web client, and optional metadata worker in one Helm chart.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/stremio --version 0.1.4
```

## Introduction

This chart deploys the [Stremio server](https://www.stremio.com/) and [Stremio Web](https://github.com/Stremio/stremio-web) client, with an optional worker that continuously prefetches ranked torrent metadata. Each component runs in its own Deployment. The worker stores verified torrent info dictionaries in PostgreSQL and warms Redis for fast server lookups.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+

## Installing the Chart

```bash
helm install stremio lbenicio-community/stremio --version 0.1.4 --namespace default
```

## Parameters

### Server

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `server.image.repository` | string | `stremio/server` | Server image repository |
| `server.image.tag` | string | `v4.22.6` | Image tag |
| `server.replicaCount` | int | `1` | Number of server replicas |
| `server.httpPort` | int | `11470` | HTTP API port |
| `server.streamPort` | int | `12470` | Streaming port |
| `server.env` | object | `{NO_CORS: "1"}` | Environment variables |
| `server.resources.requests.cpu` | string | `250m` | CPU request |
| `server.resources.requests.memory` | string | `128Mi` | Memory request |
| `server.resources.limits.cpu` | string | `1000m` | CPU limit |
| `server.resources.limits.memory` | string | `4096Mi` | Memory limit |
| `server.keel.enabled` | bool | `true` | Keel auto-update |
| `server.keel.policy` | string | `force` | Keel policy |

### Worker

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `worker.enabled` | bool | `false` | Enable the continuous metadata crawler |
| `worker.image.repository` | string | `lbenicio/stremio-worker` | Worker image |
| `worker.image.tag` | string | `0.1.0` | Worker image tag |
| `worker.args` | list | `[all]` | Crawler mode; `all`, `movies`, or `shows` |
| `worker.env` | object | `{STREMIO_WORKER_STATE_DIR: /var/lib/stremio-worker}` | Environment variables |
| `worker.extraEnv` | list | `[]` | Additional environment variables, including Secret references |
| `worker.resources` | object | requests `250m`/`256Mi`, limits `1000m`/`1Gi` | Worker resource requests and limits |

The worker requires PostgreSQL and Redis connection environment variables. Supply credentials using `worker.extraEnv` entries with Kubernetes `valueFrom.secretKeyRef`.

### Client

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `client.enabled` | bool | `true` | Enable web client |
| `client.image.repository` | string | `lbenicio/stremio-web` | Client image |
| `client.image.tag` | string | `5.2.0` | Image tag |
| `client.port` | int | `8080` | HTTP port |
| `client.resources.requests.cpu` | string | `250m` | CPU request |
| `client.resources.requests.memory` | string | `256Mi` | Memory request |
| `client.resources.limits.cpu` | string | `1000m` | CPU limit |
| `client.resources.limits.memory` | string | `512Mi` | Memory limit |

### Shared

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `hostAliases` | list | `[{hostnames:[server.stremio.lan],ip:127.0.0.1}]` | /etc/hosts entries |
| `ingress.enabled` | bool | `false` | Enable ingress for client and server |
| `ingress.className` | string | `""` | Ingress class |
| `ingress.hosts` | list | `[stremio.local]` | Host rules |
| `podAnnotations` | object | `{prometheus.io/scrape: "true"}` | Pod annotations |
| `serviceMonitor.enabled` | bool | `false` | Prometheus ServiceMonitor |
| `autoscaling.enabled` | bool | `false` | HPA for both server + client |

## Ingress with TLS

Set `service: server` on a path to route it to the Stremio server HTTP API. Paths default to the client service.

```yaml
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
  hosts:
    - host: stremio.lan
      paths:
        - path: /
          pathType: Prefix
          service: client
    - host: server.stremio.lan
      paths:
        - path: /
          pathType: Prefix
          service: server
  tls:
    - secretName: stremio-tls
      hosts:
        - stremio.lan
        - server.stremio.lan
```

## License

This chart is licensed under GPL-3.0. Stremio and Stremio Web are trademarks of their respective owners.
