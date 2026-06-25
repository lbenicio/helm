# speedtest

Prometheus exporter for internet performance metrics — runs periodic speed tests via speedtest.net and fast.com.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/speedtest
```

## Introduction

This chart deploys [d0ugal/internet-perf-exporter](https://github.com/d0ugal/internet-perf-exporter), a Prometheus exporter that periodically measures internet connection speed (download, upload, latency) and exposes the results as Prometheus metrics on `/metrics`.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+

## Installing the Chart

```bash
helm install my-release lbenicio-community/speedtest --namespace default
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `ghcr.io/d0ugal/internet-perf-exporter` | Container image repository |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `replicaCount` | int | `1` | Number of replicas |
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `8080` | Service port |
| `service.portName` | string | `metrics` | Service port name |
| `keel.enabled` | bool | `true` | Enable Keel auto-update annotations |
| `keel.policy` | string | `minor` | Keel update policy |
| `keel.trigger` | string | `poll` | Keel trigger type |
| `keel.pollSchedule` | string | `@every 24h` | Keel poll schedule |
| `podAnnotations` | object | `prometheus.io/scrape: "true"` | Pod annotations for Prometheus auto-discovery |
| `resources.requests.cpu` | string | `50m` | CPU request |
| `resources.requests.memory` | string | `64Mi` | Memory request |
| `resources.limits.cpu` | string | `100m` | CPU limit |
| `resources.limits.memory` | string | `128Mi` | Memory limit |
| `autoscaling.enabled` | bool | `false` | Enable HPA |
| `ingress.enabled` | bool | `false` | Enable ingress |

## Prometheus Metrics

The exporter exposes metrics on port `8080` at `/metrics`. By default, the chart includes pod annotations for Prometheus auto-discovery:

```yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"
  prometheus.io/path: "/metrics"
```

## Keel Auto-Update

This chart enables [Keel](https://keel.sh/) by default for automatic minor version updates:

```yaml
keel:
  enabled: true
  policy: minor
  trigger: poll
  pollSchedule: "@every 24h"
```

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
