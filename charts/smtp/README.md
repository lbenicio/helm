# smtp

A lightweight SMTP relay server for forwarding outbound mail through a smarthost.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/smtp
```

## Introduction

This chart deploys [egos-tech/smtp](https://gitlab.com/egos-tech/smtp), a minimal SMTP relay that accepts mail from trusted networks and forwards it to an external smarthost. It is designed for homelab and small-scale deployments where applications need a local mail relay without running a full mail server.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+
- An external smarthost (e.g., Gmail, SendGrid, or your ISP's relay)

## Installing the Chart

```bash
helm install my-release lbenicio-community/smtp --namespace default \
  --set smtp.relayNetworks=":10.0.0.0/8" \
  --set smtp.smarthostAddress="smtp.example.com" \
  --set smtp.smarthostPort="587"
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `registry.gitlab.com/egos-tech/smtp` | Container image repository |
| `image.tag` | string | `""` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `replicaCount` | int | `1` | Number of replicas |
| `service.type` | string | `ClusterIP` | Service type |
| `service.port` | int | `25` | SMTP service port |
| `smtp.relayNetworks` | string | `""` | Networks allowed to relay (e.g., `:10.0.0.0/8`) |
| `smtp.smarthostAliases` | string | `""` | SMTP aliases for the smarthost (e.g., `*.example.com`) |
| `smtp.smarthostAddress` | string | `""` | Smarthost address |
| `smtp.smarthostPort` | string | `""` | Smarthost port (e.g., `587`) |
| `smtp.smarthostUser` | string | `""` | Smarthost username |
| `smtp.smarthostPassword` | string | `""` | Smarthost password |
| `smtp.relayDomains` | string | `""` | Domains allowed to relay (colon-separated) |
| `resources.requests.cpu` | string | `100m` | CPU request |
| `resources.requests.memory` | string | `128Mi` | Memory request |
| `resources.limits.cpu` | string | `500m` | CPU limit |
| `resources.limits.memory` | string | `256Mi` | Memory limit |
| `autoscaling.enabled` | bool | `false` | Enable HPA |
| `autoscaling.minReplicas` | int | `1` | Minimum replicas |
| `autoscaling.maxReplicas` | int | `1` | Maximum replicas |
| `keel.enabled` | bool | `false` | Enable Keel auto-update annotations |
| `keel.policy` | string | `force` | Keel update policy |
| `keel.trigger` | string | `poll` | Keel trigger type |

## Configuration

### SMTP Relay

Configure the smarthost and relay networks to match your environment:

```yaml
smtp:
  relayNetworks: ":10.0.0.0/8 : 172.16.0.0/12"
  smarthostAddress: "smtp.gmail.com"
  smarthostPort: "587"
  smarthostUser: "myuser@gmail.com"
  smarthostPassword: "app-password-here"
  relayDomains: "example.com : another.com"
```

> **Note:** This chart exposes SMTP on port 25 via a `ClusterIP` service. It does **not** support ingress since SMTP is not an HTTP protocol. For external access, consider using a `LoadBalancer` or `NodePort` service type, or a TCP ingress controller like Traefik with TCP routes.

### Using Secrets for Credentials

For sensitive values like `smarthostPassword`, prefer using environment variables from a Kubernetes Secret:

```yaml
extraEnv:
  - name: SMARTHOST_PASSWORD
    valueFrom:
      secretKeyRef:
        name: smtp-secrets
        key: password
```

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
