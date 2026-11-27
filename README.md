# lbenicio-community Helm Charts

**Current version:** `0.1.3`

![Version](https://img.shields.io/github/v/release/lbenicio/helm?label=Version&color=blue)
[![License: GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE.txt)
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/lbenicio-community)](https://artifacthub.io/packages/search?repo=lbenicio-community)
[![Release](https://github.com/lbenicio/helm/actions/workflows/release-charts.yaml/badge.svg)](https://github.com/lbenicio/helm/actions/workflows/release-charts.yaml)
[![Publish to GHCR](https://github.com/lbenicio/helm/actions/workflows/publish-ghcr.yaml/badge.svg)](https://github.com/lbenicio/helm/actions/workflows/publish-ghcr.yaml)

A collection of production-ready Helm charts for self-hosted applications, designed for ARM64 Kubernetes clusters running on Raspberry Pi but compatible with any `linux/amd64` or `linux/arm64` node.

## Usage

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
```

```bash
helm repo update
```

```bash
helm search repo lbenicio-community
```

Or via OCI:

```bash
helm pull oci://ghcr.io/lbenicio/helm/whoami --version 0.1.0
```

## Available Charts

| Chart | Version | Description |
|-------|---------|-------------|
| [whoami](./charts/whoami) | 0.1.0 | Lightweight HTTP server that prints OS and request information — ideal for ingress and network debugging |
| [smtp](./charts/smtp) | 0.1.0 | SMTP relay service with smart-host support, relay domain filtering, and optional authentication |
| [glance](./charts/glance) | 0.1.0 | Self-hosted dashboard that aggregates RSS feeds, bookmarks, and widgets into a single page |
| [homebridge](./charts/homebridge) | 0.1.20 | HomeKit bridge with managed NFS PV/PVCs and retained recovery storage |
| [searxng](./charts/searxng) | 0.1.3 | Privacy-respecting metasearch engine with named NFS PVC support |
| [timemachine](./charts/timemachine) | 0.1.6 | Samba Time Machine server with chart-managed static local PVs and PVCs |
| [uptime-kuma](./charts/uptime-kuma) | 0.1.4 | Uptime monitoring with ConfigMap or Secret CA bundle support |
| [rpi4-v4l2-device-plugin](./charts/rpi4-v4l2-device-plugin) | 0.1.0 | Paired Raspberry Pi 4 V4L2 H.264 decoder and encoder devices for Kubernetes workloads |
| [rke2-multus](./charts/rke2-multus) | 4.3.118-lbenicio.1 | RKE2 Multus with explicit CNI installer resource bounds |
| [minio-storage](./charts/minio-storage) | 0.1.0 | Single-instance MinIO with the cluster's custom OIDC entrypoint and storage-node data path |
| [postgres-cnpg](./charts/postgres-cnpg) | 0.1.0 | Single-instance CloudNativePG cluster pinned to the local storage node |

## Installing a Chart

```bash
helm install my-release lbenicio-community/whoami \
  --namespace default \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=whoami.example.com
```

Each chart's `values.yaml` documents every available parameter. Render the full list:

```bash
helm show values lbenicio-community/whoami
```

## Chart Features

All charts ship with:

- **ARM64-native** — built and tested on `linux/arm64`, compatible with `linux/amd64`
- **Security contexts** — sensible defaults for `runAsUser`, `readOnlyRootFilesystem`, and capabilities
- **Resource requests & limits** — pre-configured with conservative defaults for small clusters
- **Optional Ingress** — Traefik-compatible with TLS and cert-manager annotations
- **Optional HPA** — horizontal pod autoscaling with configurable targets
- **Optional Keel** — automated image updates via [Keel](https://keel.sh)
- **ConfigMaps** — every chart supports injecting custom configuration
- **Persistence** — PVC support with `existingClaim` for pre-provisioned volumes
- **Service accounts** — auto-created with opt-out

## Development

```bash
# Clone the repo
git clone https://github.com/lbenicio/helm.git
```

```bash
cd helm
```

```bash
# Package all charts and rebuild the Helm index
make package
```

```bash
# Lint charts (Helm syntax + kube-linter security checks)
make lint
```

Charts are packaged into a standard Helm repository and deployed to Cloudflare Workers on every push to `main`. The site is served at [helm.lbenicio.dev](https://helm.lbenicio.dev/).

Configure the repository secrets `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` for GitHub Actions. The deployment uses the custom domain configured in [wrangler.toml](./wrangler.toml).

## Contributing

Pull requests are welcome. Please ensure:

- `make lint` passes with zero warnings
- `values.yaml` documents every configurable parameter with YAML comments
- Templates use `{{ include "<chart>.fullname" . }}` and `{{ .Release.Namespace }}` (no hardcoded names)
- Secrets, passwords, and tokens use empty placeholder values — never commit real credentials

## License

GPLv3 — see [LICENSE.txt](LICENSE.txt) for details.


Before the first deployment, configure the two Cloudflare secrets above. If the hostname still has a DNS CNAME pointing to AWS, remove that conflicting record before Wrangler creates the Worker custom domain.
