# RKE2 Multus Helm chart

This chart is based on Rancher RKE2 `rke2-multus` chart v4.3.118, with a configurable resource block for the `cni-plugins` installer init container.

The added `cniplugins.resources` values render CPU and memory requests and limits for the init container. Defaults match the previous `kube-system` LimitRange defaults: requests of 25m CPU and 64Mi memory, and limits of 500m CPU and 256Mi memory.

The original Rancher Multus and Whereabouts chart templates and images remain otherwise unchanged.

Upstream source: https://github.com/rancher/rke2-charts/tree/main-source/packages/rke2-multus
Upstream chart: https://rke2-charts.rancher.io
