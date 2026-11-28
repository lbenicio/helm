# PostgreSQL CNPG Chart

Manages the existing one-instance CloudNativePG Cluster, stable client-facing LoadBalancer Service, and optional `DatabaseRole` and `Database` resources. The values preserve the pinned PostgreSQL image, 10 GiB `local-path` data claim, storage-node placement, superuser Secret reference, ClusterIP, and MetalLB address.

`databaseRoles` accepts CloudNativePG `DatabaseRole` fields, with `resourceName` optionally overriding the Kubernetes object name. `databases` accepts CloudNativePG `Database` fields, with `resourceName` optionally overriding the Kubernetes object name. The chart supplies the current cluster name and release namespace for both resource types. For example:

```yaml
databaseRoles:
  - name: app
    login: true
    superuser: false
    createdb: false
    passwordSecret:
      name: stremio-postgres-app
    databaseRoleReclaimPolicy: retain

databases:
  - name: app
    owner: app
    databaseReclaimPolicy: retain
```

The chart sets the PostgreSQL CPU request to `250m` by default.

```sh
helm upgrade --install postgres-cnpg oci://ghcr.io/lbenicio/helm/postgres-cnpg \
  --version 0.1.1 \
  --namespace default \
  --values src/storage/postgres/values.yaml \
  --take-ownership --rollback-on-failure --wait --timeout 10m
```

The first installation adopts the existing Cluster and Service without recreating the data claim. A change to the single PostgreSQL instance's pod resources can cause a brief database restart while CloudNativePG reconciles it.
