# uptime-kuma

A self-hosted monitoring tool like Uptime Robot, with a beautiful UI for tracking service uptime, response time, and certificates.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/uptime-kuma --version 0.1.4
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
| `customCA.enabled` | bool | `false` | Mount an additional CA and set `NODE_EXTRA_CA_CERTS` |
| `customCA.configMap.name` | string | `""` | Existing ConfigMap containing the CA bundle |
| `customCA.configMap.key` | string | `ca.pem` | ConfigMap key containing the CA bundle |
| `customCA.configMap.create` | bool | `false` | Let Helm create the CA ConfigMap |
| `customCA.configMap.content` | string | `""` | PEM contents, normally supplied with `--set-file` |
| `customCA.secret.name` | string | `""` | Existing Secret source, as an alternative to ConfigMap |
| `customCA.secret.key` | string | `ca.crt` | Secret key containing the CA bundle |
| `customCA.mountPath` | string | `/etc/ssl/certs/custom-ca.pem` | Mounted file and `NODE_EXTRA_CA_CERTS` path |
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

### Additional CA bundle

Mount a ConfigMap created by this chart or an existing ConfigMap/Secret as an
additional trust root for outbound TLS connections. The chart mounts the file
read-only and configures Node.js to load it through `NODE_EXTRA_CA_CERTS`.

```yaml
customCA:
  enabled: true
  configMap:
    create: true
    name: uptimekuma-ca
    key: ca.pem
  mountPath: /etc/uptime-kuma/ca.pem
```

Provide the PEM bundle at install time without duplicating it in values:

```sh
helm upgrade --install uptimekuma lbenicio-community/uptime-kuma \
  --version 0.1.4 --namespace default -f values.yaml \
  --set-file customCA.configMap.content=ca.pem
```

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
## Extra volumes

Use `extraVolumeMounts` and `extraVolumes` to add mounts and pod volumes, for example to mount an additional CA bundle from a ConfigMap.
