# PostgreSQL CNPG Chart

Manages the existing one-instance CloudNativePG Cluster and the stable client-facing LoadBalancer Service. The values preserve the pinned PostgreSQL image, 10 GiB `local-path` data claim, storage-node placement, superuser Secret reference, ClusterIP, and MetalLB address.

The chart sets the PostgreSQL CPU request to `250m` by default.

```sh
helm upgrade --install postgres-cnpg lbenicio-community/postgres-cnpg \
  --version 0.1.0 \
  --namespace default \
  --values src/storage/postgres/values.yaml \
  --take-ownership --rollback-on-failure --wait --timeout 10m
```

The first installation adopts the existing Cluster and Service without recreating the data claim. A change to the single PostgreSQL instance's pod resources can cause a brief database restart while CloudNativePG reconciles it.
