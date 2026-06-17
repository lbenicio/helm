# k8s-v2 Helm Charts

[![Release Charts](https://github.com/lbenicio/helm/actions/workflows/release-charts.yaml/badge.svg)](https://github.com/lbenicio/helm/actions/workflows/release-charts.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.txt)

A collection of production-ready Helm charts for self-hosted applications, designed for ARM64 Kubernetes clusters running on Raspberry Pi but compatible with any `linux/amd64` or `linux/arm64` node.

## Usage

```bash
helm repo add k8s-v2 https://lbenicio.github.io/helm
helm repo update
helm search repo k8s-v2
```

## Available Charts

| Chart | Version | Description |
|-------|---------|-------------|
| [whoami](./charts/whoami) | 0.1.0 | Lightweight HTTP server that prints OS and request information — ideal for ingress and network debugging |
| [smtp](./charts/smtp) | 0.1.0 | SMTP relay service with smart-host support, relay domain filtering, and optional authentication |
| [glance](./charts/glance) | 0.1.0 | Self-hosted dashboard that aggregates RSS feeds, bookmarks, and widgets into a single page |
| [homebridge](./charts/homebridge) | 0.1.0 | HomeKit bridge for non-HomeKit smart home devices, with host networking and Bluetooth support |

## Installing a Chart

```bash
helm install my-release k8s-v2/whoami \
  --namespace default \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=whoami.example.com
```

Each chart's `values.yaml` documents every available parameter. Render the full list:

```bash
helm show values k8s-v2/whoami
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
cd helm

# Package all charts and rebuild the Helm index
make package

# Lint charts (Helm syntax + kube-linter security checks)
make lint
```

Charts are packaged and published to GitHub Pages automatically on every push to `main`.

## Contributing

Pull requests are welcome. Please ensure:

- `make lint` passes with zero warnings
- `values.yaml` documents every configurable parameter with YAML comments
- Templates use `{{ include "<chart>.fullname" . }}` and `{{ .Release.Namespace }}` (no hardcoded names)
- Secrets, passwords, and tokens use empty placeholder values — never commit real credentials

## License

MIT — see [LICENSE.txt](LICENSE.txt) for details.
