# uptime-kuma

A self-hosted monitoring tool like Uptime Robot, with a beautiful UI for tracking service uptime, response time, and certificates.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/uptime-kuma
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `louislam/uptime-kuma` | Container image repository |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `replicaCount` | int | `1` | Number of replicas |
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `3001` | Service port |
| `ingress.enabled` | bool | `false` | Enable ingress |
| `ingress.className` | string | `""` | Ingress class name |
| `ingress.hosts` | list | `[{"host":"uptime.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress host rules |
| `ingress.tls` | list | `[]` | Ingress TLS configuration |
| `persistence.enabled` | bool | `true` | Enable PVC for SQLite database |
| `persistence.size` | string | `4Gi` | PVC size |
| `persistence.storageClass` | string | `local-path` | Storage class |
| `resources.requests.cpu` | string | `100m` | CPU request |
| `resources.requests.memory` | string | `128Mi` | Memory request |
| `resources.limits.cpu` | string | `500m` | CPU limit |
| `resources.limits.memory` | string | `512Mi` | Memory limit |
| `keel.enabled` | bool | `true` | Enable Keel auto-update annotations |
| `keel.policy` | string | `force` | Keel update policy |
| `keel.trigger` | string | `poll` | Keel trigger type |
| `keel.pollSchedule` | string | `@every 24h` | Keel poll schedule |
| `env.TZ` | string | `UTC` | Container timezone |

## Configuration

### Ingress

```yaml
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
  hosts:
    - host: uptime.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: uptime-tls
      hosts:
        - uptime.example.com
```

### Persistence

Uptime Kuma stores its SQLite database (`kuma.db`) in `/app/data`. A PVC is enabled by default to persist monitors, settings, and history across restarts.

```yaml
persistence:
  enabled: true
  size: 4Gi
  storageClass: local-path
```

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
