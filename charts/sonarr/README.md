# Arr Helm Chart

Generic Helm chart for *arr family applications (Sonarr, Radarr, Prowlarr, Bazarr, Lidarr, etc.) using linuxserver.io images.

## Usage

```bash
helm repo add lbenicio-community https://helm.lbenicio.dev

# Sonarr
helm upgrade --install sonarr lbenicio-community/arr \
  --set image.repository=lscr.io/linuxserver/sonarr \
  --set image.tag=develop \
  --set service.port=8989 \
  --set ingress.hosts[0].host=sonarr.lan \
  --set ingress.tls[0].secretName=sonarr-tls \
  --set ingress.tls[0].hosts[0]=sonarr.lan \
  --set persistence.config[0].name=config \
  --set persistence.config[0].mountPath=/config \
  --set persistence.config[0].size=10Gi

# Radarr
helm upgrade --install radarr lbenicio-community/arr \
  --set image.repository=lscr.io/linuxserver/radarr \
  --set service.port=7878 \
  --set ingress.hosts[0].host=radarr.lan
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Image repository | `lscr.io/linuxserver/sonarr` |
| `image.tag` | Image tag | `develop` |
| `service.port` | Service port | `8989` |
| `controller.type` | StatefulSet or Deployment | `StatefulSet` |
| `ingress.enabled` | Enable ingress | `false` |
| `persistence.config` | List of PVC definitions | `[]` |
