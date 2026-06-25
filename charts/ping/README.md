# ping

A Helm chart for the Prometheus Blackbox Exporter, which probes endpoints over HTTP, HTTPS, DNS, TCP, and ICMP.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/ping
```

## Introduction

This chart deploys the [Prometheus Blackbox Exporter](https://github.com/prometheus/blackbox_exporter), a probe-based monitoring tool that allows Prometheus to monitor external endpoints through blackbox probing. It ships with pre-configured modules for HTTP, HTTPS, TCP, SSH, POP3S, IRC, and ICMP probing.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+

## Installing the Chart

```bash
helm install my-release lbenicio-community/ping --namespace default
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `prom/blackbox-exporter` | Container image repository |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `replicaCount` | int | `1` | Number of replicas |
| `args` | list | `["--config.file=/config/blackbox.yml"]` | Container arguments |
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `9115` | Service port |
| `config.create` | bool | `true` | Create the ConfigMap for blackbox.yml |
| `config.blackboxYml` | string | (see values.yaml) | Blackbox exporter module configuration |
| `resources.requests.cpu` | string | `100m` | CPU request |
| `resources.requests.memory` | string | `128Mi` | Memory request |
| `resources.limits.cpu` | string | `250m` | CPU limit |
| `resources.limits.memory` | string | `256Mi` | Memory limit |
| `keel.enabled` | bool | `true` | Enable Keel auto-update annotations |
| `keel.policy` | string | `minor` | Keel update policy |
| `keel.trigger` | string | `poll` | Keel trigger type |
| `keel.pollSchedule` | string | `@every 24h` | Keel poll schedule |
| `keel.matchTag` | string | `true` | Keel match tag pattern |
| `containerSecurityContext.readOnlyRootFilesystem` | bool | `true` | Mount root filesystem as read-only |
| `containerSecurityContext.runAsNonRoot` | bool | `true` | Run container as non-root user |
| `containerSecurityContext.runAsUser` | int | `65534` | User ID to run the container |

## Configuration

### blackbox.yml

The chart creates a ConfigMap from `config.blackboxYml`. Override it to customize the probing modules:

```yaml
config:
  blackboxYml: |-
    modules:
      http_2xx:
        prober: http
        timeout: 5s
        http:
          valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
          preferred_ip_protocol: "ip4"

      tcp_connect:
        prober: tcp
        timeout: 5s

      icmp:
        prober: icmp
```

Refer to the [Blackbox Exporter configuration docs](https://github.com/prometheus/blackbox_exporter#configuration) for all available modules and options.

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
