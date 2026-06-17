# glance

A self-hosted dashboard that puts all your feeds, widgets, and information at a glance.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/glance
```

## Introduction

This chart deploys [Glance](https://github.com/glanceapp/glance), a fast and customizable startpage/dashboard application written in Go. It aggregates RSS feeds, Reddit, Hacker News, weather, bookmarks, and more into a single page. The chart ships with a default `glance.yml` configuration that you can override to build your own dashboard layout.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+

## Installing the Chart

```bash
helm install my-release lbenicio-community/glance --namespace default
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `glanceapp/glance` | Container image repository |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `replicaCount` | int | `1` | Number of replicas |
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `8080` | HTTP service port |
| `ingress.enabled` | bool | `false` | Enable ingress |
| `ingress.className` | string | `""` | Ingress class name |
| `ingress.hosts` | list | `[{"host":"glance.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress host rules |
| `ingress.tls` | list | `[]` | Ingress TLS configuration |
| `config.create` | bool | `true` | Create the ConfigMap for glance.yml |
| `config.glanceYaml` | string | (see values.yaml) | Glance configuration (glance.yml) |
| `config.userCSS` | string | `/* Add your custom CSS here */` | Custom CSS injected into the UI |
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

## Configuration

### glance.yml

The chart creates a ConfigMap from `config.glanceYaml`. Override it to customize your dashboard with widgets like RSS, Hacker News, Reddit, weather, and more:

```yaml
config:
  glanceYaml: |-
    server:
      port: 8080

    pages:
      - name: My Dashboard
        columns:
          - size: small
            widgets:
              - type: calendar
                first-day-of-week: monday

          - size: full
            widgets:
              - type: rss
                title: News
                feed: https://example.com/feed.xml

              - type: weather
                location: London, UK

              - type: hacker-news
```

Refer to the [Glance configuration docs](https://github.com/glanceapp/glance/blob/main/docs/configuration.md) for all available widgets and options.

### Ingress with TLS

Expose Glance securely via ingress with cert-manager:

```yaml
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
  hosts:
    - host: glance.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: glance-tls
      hosts:
        - glance.example.com
```

### Custom CSS

Inject custom styling into the Glance UI:

```yaml
config:
  userCSS: |
    body { font-family: 'JetBrains Mono', monospace; }
    .widget { border-radius: 8px; }
```

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
