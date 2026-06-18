# pod-cleaner

A Helm chart that deploys a CronJob to periodically clean up completed (Succeeded) pods from the cluster.

## TL;DR

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm install my-release lbenicio-community/pod-cleaner
```

## Introduction

This chart deploys a Kubernetes CronJob that runs `kubectl delete pod --field-selector=status.phase=Succeeded` on a configurable schedule. It uses [bitnami/kubectl](https://hub.docker.com/r/bitnami/kubectl) as the container image.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.x+
- ClusterRole RBAC permissions (the chart creates its own ClusterRole and ClusterRoleBinding)

## RBAC

The chart creates:

- **ServiceAccount** — identity for the CronJob pods
- **ClusterRole** — grants `list` and `delete` verbs on `pods` resources
- **ClusterRoleBinding** — binds the ServiceAccount to the ClusterRole

## Installing the Chart

```bash
helm install my-release lbenicio-community/pod-cleaner --namespace default
```

## Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `image.repository` | string | `bitnami/kubectl` | Container image repository |
| `image.tag` | string | `latest` | Image tag (defaults to Chart.appVersion) |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy |
| `schedule` | string | `0 * * * *` | Cron schedule for the cleanup job |
| `namespace` | string | `default` | Namespace to clean up pods from |
| `successfulJobsHistoryLimit` | int | `1` | Number of successful jobs to keep |
| `failedJobsHistoryLimit` | int | `1` | Number of failed jobs to keep |
| `resources.requests.cpu` | string | `10m` | CPU request |
| `resources.requests.memory` | string | `64Mi` | Memory request |
| `resources.limits.cpu` | string | `50m` | CPU limit |
| `resources.limits.memory` | string | `128Mi` | Memory limit |
| `nodeSelector` | object | `{}` | Node selector for pod assignment |
| `tolerations` | list | `[]` | Tolerations for pod assignment |
| `affinity` | object | `{}` | Affinity for pod assignment |
| `serviceAccount.create` | bool | `true` | Create a ServiceAccount |
| `serviceAccount.name` | string | `""` | ServiceAccount name (defaults to fullname) |

## Configuration

### Custom schedule

```yaml
schedule: "*/30 * * * *"   # Every 30 minutes
```

### Target a specific namespace

```yaml
namespace: "production"
```

### Run on control-plane nodes

```yaml
tolerations:
  - key: node-role.kubernetes.io/control-plane
    operator: Exists
    effect: NoSchedule
```

## License

This chart is licensed under GPLv3.

---

Made with ❤️ by [lbenicio](https://lbenicio.dev/)
