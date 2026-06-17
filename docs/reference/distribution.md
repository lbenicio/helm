# Distribution

Charts are distributed via two channels:

## GitHub Pages

Traditional Helm repository served at `https://helm.lbenicio.dev/`.

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev/
helm repo update
helm search repo lbenicio-community
helm install my-release lbenicio-community/whoami
```

The `index.yaml` and `.tgz` packages are built by GitHub Actions on push to `main` and deployed via `actions/deploy-pages`.

## GitHub Container Registry (GHCR)

OCI-based distribution for individual charts.

```bash
helm pull oci://ghcr.io/lbenicio/helm/whoami --version 0.1.0
helm install my-release oci://ghcr.io/lbenicio/helm/whoami --version 0.1.0
```

## Workflows

| File | Trigger | Action |
|------|---------|--------|
| `release-charts.yaml` | Push to `main` (charts/) | Package → Deploy to GitHub Pages |
| `publish-ghcr.yaml` | Push to `main` (charts/) | Package → Push OCI to GHCR |
