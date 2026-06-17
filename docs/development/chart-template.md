# Chart Template

Use this as the starting point for new charts.

## Directory structure

```
charts/<name>/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default values with YAML comments
├── README.md           # Chart documentation
├── tests/
│   ├── deployment_test.yaml
│   ├── service_test.yaml
│   └── ingress_test.yaml  # Skip if no HTTP ingress
└── templates/
    ├── _helpers.tpl        # Name/label helpers
    ├── deploy.yaml         # Deployment or StatefulSet
    ├── svc.yaml            # Service
    ├── ingress.yaml        # Ingress (conditional)
    ├── hpa.yaml            # HPA (conditional)
    ├── serviceaccount.yaml # ServiceAccount (conditional)
    └── configmap.yaml      # ConfigMap (conditional)
```

## Chart.yaml

```yaml
apiVersion: v2
name: <name>
description: A Helm chart for <description>
type: application
version: 0.1.0
appVersion: "latest"
```

## Required values.yaml sections

- `image` (repository, tag, pullPolicy)
- `imagePullSecrets`
- `nameOverride` / `fullnameOverride`
- `replicaCount`
- `serviceAccount` (create, name)
- `podAnnotations` / `podLabels`
- `podSecurityContext` / `containerSecurityContext`
- `service` (type, port)
- `ingress` (enabled, className, hosts, tls)
- `resources` (requests, limits)
- `autoscaling` (enabled, minReplicas, maxReplicas)
- `keel` (enabled, policy, trigger, pollSchedule)
- `nodeSelector`, `tolerations`, `affinity`
- `persistence` (if applicable)
- `config` (if using ConfigMaps)
- `extraEnv`, `extraVolumes`, `extraVolumeMounts`
