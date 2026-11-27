# Raspberry Pi 4 V4L2 Device Plugin

This chart installs the upstream generic Kubernetes device plugin and exposes
only the Raspberry Pi 4 H.264 decoder (`/dev/video10`) and encoder
(`/dev/video11`) as one schedulable resource. It does not mount the rest of
the host's `/dev` directory.

Kubernetes requires device-plugin pods to access the kubelet device-plugin
socket. The plugin pod therefore runs privileged, while consuming applications
receive only the paired video devices allocated through the extended resource.
The chart disables service-account token mounting, grants no Kubernetes API
RBAC, and sets CPU and memory requests and limits. Restrict its node affinity to
nodes with these Pi devices and tolerate only the taints required by those
nodes.

## Install

```sh
helm upgrade --install rpi4-v4l2-device-plugin \
  lbenicio-community/rpi4-v4l2-device-plugin \
  --version 0.1.0 \
  --namespace default \
  --values values.yaml \
  --rollback-on-failure --wait --timeout 5m
```

After the plugin registers with kubelet, a workload requests one paired device
with this resource limit:

```yaml
resources:
  limits:
    devic.es/rpi4-v4l2m2m: 1
```

Kubernetes schedules that pod only on a node advertising the device. The
plugin then supplies the two device nodes and their device-cgroup permissions.

## Values

| Key | Default | Description |
| --- | --- | --- |
| `image.repository` | `squat/generic-device-plugin` | Upstream plugin image repository. |
| `image.tag` | `f7c3291` | Pinned upstream commit tag. |
| `image.pullPolicy` | `IfNotPresent` | Image pull policy. |
| `resourceDomain` | `devic.es` | Extended-resource domain. |
| `resourceName` | `rpi4-v4l2m2m` | Name of the paired device resource. |
| `resources` | See `values.yaml` | Plugin pod CPU and memory requests and limits. |
| `nodeSelector` | `{}` | Node selector for nodes with both V4L2 devices. |
| `affinity` | `{}` | Node affinity for nodes with both V4L2 devices. |
| `tolerations` | `[]` | Tolerations for node taints. |
| `podLabels` | `{}` | Additional pod labels. |
| `podAnnotations` | `{}` | Additional pod annotations. |
