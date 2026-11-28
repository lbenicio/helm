# MinIO Storage Chart

Manages the existing single-instance MinIO StatefulSet, ConfigMap, and LoadBalancer Service. It preserves `/k8s/minio`, the storage-node scheduling rules, the custom OIDC-aware image and entrypoint, TLS Secrets, and the existing service address.

CPU and memory bounds, non-root UID/GID, read-only root filesystem, dropped capabilities, and the `RuntimeDefault` seccomp profile are configured in `values.yaml`. The chart defaults the CPU request to `250m`. The MinIO process listens on an unprivileged pod port; the Service still exposes HTTPS on port 443. Its writable home and temporary files use `emptyDir` volumes, while `/k8s/minio` and its TLS certificates remain mounted read-only or at their existing paths as appropriate.

```sh
helm upgrade --install minio lbenicio-community/minio-storage \
  --version 0.1.1 \
  --namespace default \
  --values src/storage/minio/values.yaml \
  --take-ownership --rollback-on-failure --wait --timeout 10m
```

The first installation adopts the existing resources with Helm's `--take-ownership` option. The data remains on the existing storage-node path.
