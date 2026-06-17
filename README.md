# k8s-v2 Helm Charts

Helm chart repository for the k8s-v2 homelab cluster.

## Available Charts

| Chart | Description |
|-------|-------------|
| whoami | Traefik whoami test service |
| smtp | SMTP relay service |
| glance | Glance dashboard |

## Usage

```bash
helm repo add k8s-v2 https://<github-user>.github.io/helm
helm repo update
helm install whoami k8s-v2/whoami --namespace default
```

## Development

```bash
make package    # Package all charts and rebuild index
```
