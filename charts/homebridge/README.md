# homebridge

HomeKit support for the impatient — bring HomeKit to non-HomeKit smart home devices.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/homebridge
```

## Introduction

This chart deploys [Homebridge](https://homebridge.io/), a lightweight Node.js server that emulates the iOS HomeKit API, allowing you to control smart home devices that do not natively support HomeKit. It supports hundreds of plugins for devices like cameras, lights, locks, thermostats, and more. The chart includes options for host networking (required for mDNS/Bonjour discovery), Bluetooth device passthrough, and persistent storage for your Homebridge configuration.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+
- A Kubernetes node with the necessary capabilities (hostNetwork, privileged mode) if using Bluetooth or mDNS discovery

## Installing the Chart

```bash
helm install my-release lbenicio-community/homebridge --namespace default \
  --set persistence.enabled=true \
  --set persistence.storageClass=local-storage \
  --set persistence.localPath=/var/local/k8s/homebridge
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `homebridge/homebridge` | Container image repository |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `replicaCount` | int | `1` | Number of replicas |
| `hostNetwork` | bool | `false` | Enable hostNetwork for mDNS/Bonjour discovery |
| `bluetooth.enabled` | bool | `false` | Enable Bluetooth hostPath volume mount |
| `bluetooth.hostPath` | string | `/sys/class/bluetooth/hci0` | Host path for Bluetooth device |
| `service.type` | string | `ClusterIP` | Service type |
| `service.httpPort` | int | `8581` | HTTP port for the web UI |
| `service.ports` | list | (4 ports) | Service ports (http, bonjour, alexa, controller) |
| `ingress.enabled` | bool | `false` | Enable ingress for the web UI |
| `ingress.className` | string | `""` | Ingress class name |
| `ingress.hosts` | list | `[{"host":"homebridge.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress host rules |
| `ingress.tls` | list | `[]` | Ingress TLS configuration |
| `persistence.enabled` | bool | `false` | Enable persistent storage |
| `persistence.existingClaim` | string | `""` | Use an existing PVC (claim name) |
| `persistence.storageClass` | string | `local-storage` | Storage class name |
| `persistence.size` | string | `10Gi` | Storage size |
| `persistence.accessMode` | string | `ReadWriteOnce` | Access mode |
| `persistence.localPath` | string | `/var/local/k8s/homebridge` | Local path on the host |
| `persistence.nodeAffinityHost` | string | `""` | Node affinity hostname for local PV |
| `containerSecurityContext.runAsUser` | int | `1000` | User ID to run the container |
| `resources.requests.cpu` | string | `100m` | CPU request |
| `resources.requests.memory` | string | `128Mi` | Memory request |
| `resources.limits.cpu` | string | `500m` | CPU limit |
| `resources.limits.memory` | string | `256Mi` | Memory limit |
| `autoscaling.enabled` | bool | `false` | Enable HPA |
| `keel.enabled` | bool | `false` | Enable Keel auto-update annotations |

## Configuration

### Persistence

Enable persistent storage to retain your Homebridge configuration, plugins, and accessories across restarts:

```yaml
persistence:
  enabled: true
  storageClass: local-storage
  size: 10Gi
  accessMode: ReadWriteOnce
  localPath: /var/local/k8s/homebridge
  nodeAffinityHost: node01
```

To use an existing PVC instead of creating a new one:

```yaml
persistence:
  enabled: true
  existingClaim: "my-existing-homebridge-pvc"
```

### Host Network & Bluetooth

Homebridge uses mDNS (Bonjour) for HomeKit device discovery, which requires `hostNetwork` when running in a cluster. Enable it along with Bluetooth passthrough if you have BLE accessories:

```yaml
hostNetwork: true
bluetooth:
  enabled: true
  hostPath: /sys/class/bluetooth/hci0
```

**Security note:** Host networking and privileged mode expand the container's access to the node. Only enable these on trusted workloads and dedicated nodes.

### Ingress

Expose the Homebridge web UI through an ingress controller:

```yaml
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
  hosts:
    - host: homebridge.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: homebridge-cert
      hosts:
        - homebridge.example.com
```

### Environment Variables

Customize the container environment, e.g., timezone or disabling Avahi:

```yaml
env:
  TZ: "America/Sao_Paulo"
  ENABLE_AVAHI: "0"
```

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
