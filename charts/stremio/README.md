# stremio

Complete Stremio media server and web client — deploy both with a single Helm chart.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/stremio
```

## Introduction

This chart deploys both the [Stremio server](https://www.stremio.com/) and the [Stremio Web](https://github.com/Stremio/stremio-web) client. The server handles streaming and metadata, while the web client provides the browser-based UI. Both are deployed as separate Deployments within a single release, with shared configuration for host aliases, autoscaling, and Prometheus monitoring.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+

## Installing the Chart

```bash
helm install stremio lbenicio-community/stremio --namespace default
```

## Parameters

### Server

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `server.image.repository` | string | `stremio/server` | Server image repository |
| `server.image.tag` | string | `""` | Image tag |
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

### Client

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `client.enabled` | bool | `true` | Enable web client |
| `client.image.repository` | string | `lbenicio/stremio-web` | Client image |
| `client.image.tag` | string | `""` | Image tag |
| `client.port` | int | `8080` | HTTP port |
| `client.resources.requests.cpu` | string | `250m` | CPU request |
| `client.resources.requests.memory` | string | `256Mi` | Memory request |
| `client.resources.limits.cpu` | string | `1000m` | CPU limit |
| `client.resources.limits.memory` | string | `512Mi` | Memory limit |

### Shared

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `hostAliases` | list | `[{hostnames:[server.stremio.lan],ip:127.0.0.1}]` | /etc/hosts entries |
| `ingress.enabled` | bool | `false` | Enable ingress for client |
| `ingress.className` | string | `""` | Ingress class |
| `ingress.hosts` | list | `[stremio.local]` | Host rules |
| `podAnnotations` | object | `{prometheus.io/scrape: "true"}` | Pod annotations |
| `serviceMonitor.enabled` | bool | `false` | Prometheus ServiceMonitor |
| `autoscaling.enabled` | bool | `false` | HPA for both server + client |

## Ingress with TLS

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
  tls:
    - secretName: stremio-tls
      hosts:
        - stremio.lan
```

## License

This chart is licensed under GPL-3.0. Stremio and Stremio Web are trademarks of their respective owners.
