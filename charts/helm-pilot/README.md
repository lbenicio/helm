# Helm Pilot

AI-powered Helm management dashboard for Kubernetes clusters. Manage Helm releases visually with OIDC authentication and Gemini AI assistance.

## Features

- 📦 Helm release management (install, upgrade, rollback, delete)
- 📊 Cluster resource monitoring (CPU, memory, pods, quotas)
- 🔐 OIDC authentication (PocketID, Google, etc.)
- 🤖 AI-powered assistance via Gemini
- 📜 Activity logging and audit trail
- 🔍 Multi-repository Helm chart search

## Prerequisites

- Kubernetes 1.21+
- Helm 3.x
- OIDC provider (e.g., PocketID) for authentication

## Installation

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev
helm upgrade --install helm-pilot lbenicio-community/helm-pilot \
  --namespace default \
  --set config.oidc.clientId=YOUR_CLIENT_ID \
  --set config.oidc.clientSecret=YOUR_CLIENT_SECRET
```

## OIDC Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `config.oidc.enabled` | Enable OIDC authentication | `false` |
| `config.oidc.clientId` | OIDC client ID | `""` |
| `config.oidc.clientSecret` | OIDC client secret | `""` |
| `config.oidc.issuerUrl` | OIDC issuer URL | `https://pocketid.lan` |
| `config.oidc.scopes` | OIDC scopes | `openid profile email` |
| `config.oidc.skipTlsVerify` | Skip TLS verification | `true` |
| `config.oidc.caCertSecret` | Secret with custom CA cert | `root-secret` |
| `config.appUrl` | Public app URL for redirects | `""` |

### OIDC Callback URL

Register the following redirect URL in your OIDC provider:
```
https://helm.lan/auth/callback
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Image repository | `lbenicio/helm-pilot` |
| `image.tag` | Image tag | `""` (appVersion) |
| `replicaCount` | Number of replicas | `1` |
| `serviceAccount.create` | Create ServiceAccount with RBAC | `true` |
| `ingress.enabled` | Enable ingress | `false` |
| `resources.requests.cpu` | CPU request | `100m` |
| `resources.requests.memory` | Memory request | `128Mi` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `256Mi` |
