# MinIO Storage Chart

Manages the existing single-instance MinIO StatefulSet, ConfigMap, and LoadBalancer Service. It preserves `/k8s/minio`, the storage-node scheduling rules, the custom OIDC-aware image and entrypoint, TLS Secrets, and the existing service address.

CPU and memory bounds are configured in `values.yaml`. This chart defaults the CPU request to `250m`.

```sh
helm upgrade --install minio lbenicio-community/minio-storage \
  --version 0.1.0 \
  --namespace default \
  --values src/storage/minio/values.yaml \
  --take-ownership --rollback-on-failure --wait --timeout 10m
```

The first installation adopts the existing resources with Helm's `--take-ownership` option. The data remains on the existing storage-node path.
