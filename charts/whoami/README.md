# whoami

A simple HTTP server that returns request information — useful for testing ingress, load balancing, and network policies.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/whoami
```

## Introduction

This chart deploys [traefik/whoami](https://github.com/traefik/whoami), a lightweight Go web server that echoes back HTTP request details (headers, host, IP, URL). It is ideal for debugging ingress controllers, verifying TLS termination, and testing cluster networking.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+

## Installing the Chart

```bash
helm install my-release lbenicio-community/whoami --namespace default
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `traefik/whoami` | Container image repository |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `replicaCount` | int | `1` | Number of replicas |
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `80` | Service port |
| `ingress.enabled` | bool | `false` | Enable ingress |
| `ingress.className` | string | `""` | Ingress class name |
| `ingress.hosts` | list | `[{"host":"whoami.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress host rules |
| `ingress.tls` | list | `[]` | Ingress TLS configuration |
| `resources.requests.cpu` | string | `100m` | CPU request |
| `resources.requests.memory` | string | `128Mi` | Memory request |
| `resources.limits.cpu` | string | `500m` | CPU limit |
| `resources.limits.memory` | string | `256Mi` | Memory limit |
| `autoscaling.enabled` | bool | `false` | Enable HPA |
| `autoscaling.minReplicas` | int | `1` | Minimum replicas |
| `autoscaling.maxReplicas` | int | `1` | Maximum replicas |
| `autoscaling.targetCPUUtilizationPercentage` | int | `90` | Target CPU utilization |
| `keel.enabled` | bool | `false` | Enable Keel auto-update annotations |
| `keel.policy` | string | `force` | Keel update policy |
| `keel.trigger` | string | `poll` | Keel trigger type |
| `keel.pollSchedule` | string | `@every 24h` | Keel poll schedule |

## Configuration

### Ingress

Enable ingress to expose whoami externally. TLS can be configured with cert-manager by adding the appropriate annotations:

```yaml
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
  hosts:
    - host: whoami.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: whoami-cert
      hosts:
        - whoami.example.com
```

### Keel Auto-Update

This chart supports [Keel](https://keel.sh/) for automatic image updates:

```yaml
keel:
  enabled: true
  policy: minor
  trigger: poll
  pollSchedule: "@every 1h"
```

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
