# Prometheus Thanos

## Introduction

[Thanos](https://github.com/thanos-io/thanos/) is a set of components that can be composed into a highly available metric system with unlimited storage capacity, which can be added seamlessly on top of existing Prometheus deployments.

Thanos leverages the Prometheus 2.0 storage format to cost-efficiently store historical metric data in any object storage while retaining fast query latencies. Additionally, it provides a global query view across all Prometheus installations and can merge data from Prometheus HA pairs on the fly..

## Prerequisites

* Has been tested on Kubernetes 1.11+

## Installing the Chart

To install the chart you have to set `objStoreConfig`.
To install the chart with the release name `prometheus-thanos`, run the following command:

```bash
helm install kiwigrid/prometheus-thanos --name prometheus-thanos --values=my-values.yaml
```

## Using Sidcar Configmap Watcher

To enable the sidecar you can set `ruler.sidecar.enabled` to `true`. The sidcar will then watch all configmaps and if there is a configmap with label named like `ruler.sidecar.watchLabel` the the sidecar will use the content inside the config directory of the ruler and will notify the ruler to reload the config files.

An example configmap will look like:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:  
  name: custom-config-map
  labels:
    thanos_alert_config: "1"
data:
  custom-external-rules.yaml: |-
    groups:
    - name: custom_external_rules_group
      rules:
      - alert: custom_alert
        annotations:
          description: "add your desc here"
          summary: "add your summary here"
        expr: up
        for: 10m
        labels:
          severity: warn
```

## Uninstalling the Chart

To uninstall/delete the `prometheus-thanos` deployment:

```bash
helm delete prometheus-thanos
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge prometheus-thanos`

## Configuration

The following table lists the configurable parameters of the prometheus-thanos chart and their default values.

| Parameter                                  | Description                               | Default                            |
| ------------------------------------------ | ----------------------------------------- | ---------------------------------- |
| `querier.replicaCount` | replica count for querier | `1` |
| `querier.updateStrategy` | Deployment update strategy | `type: RollingUpdate` |
| `querier.image.repository` | Docker image repo for querier | `quay.io/thanos/thanos` |
| `querier.image.tag` | Docker image tag for querier | `v0.7.0` |
| `querier.image.pullPolicy` | Docker image pull policy for querier| `IfNotPresent` |
| `querier.additionalLabels` | Additional labels on querier pods| `{}` |
| `querier.additionalAnnotations` | Additional annotations on querier pods| `{}` |
| `storeGateway.replicaCount` |  for store gateway | `1` |
| `storeGateway.updateStrategy` | StatefulSet update strategy | `type: RollingUpdate` |
| `storeGateway.image.repository` | Docker image repo for store gateway | `quay.io/thanos/thanos` |
| `storeGateway.image.tag` | Docker image tag for store gateway | `v0.7.0` |
| `storeGateway.image.pullPolicy` | Docker image pull policy for store gateway | `IfNotPresent` |
| `storeGateway.additionalLabels` | Additional labels on store gateway pods| `{}` |
| `storeGateway.additionalAnnotations` | Additional annotations on store gateway pods| `{}` |
| `compact.updateStrategy` | StatefulSet update strategy | `type: RollingUpdate` |
| `compact.image.repository` | Docker image repo for store gateway | `quay.io/thanos/thanos` |
| `compact.image.tag` | Docker image tag for store gateway | `v0.7.0` |
| `compact.image.pullPolicy` | Docker image pull policy for store gateway | `IfNotPresent` |
| `compact.additionalLabels` | Additional labels on compactor pod| `{}` |
| `compact.additionalAnnotations` | Additional annotations on compactor pod| `{}` |
| `compact.affinity` | Affinity | `{}` |
| `compact.tolerations` | Tolerations | `[]` |
| `compact.volumeMounts` | Additional volume mounts | `nil` |
| `compact.volumes` | Additional volumes | `nil` |
| `compact.persistentVolume.enabled` | Persistent volume enabled | `false` |
| `compact.persistentVolume.accessModes` | Persistent volume accessModes | `[ReadWriteOnce]` |
| `compact.persistentVolume.annotations` | Persistent volume annotations | `{}` |
| `compact.persistentVolume.existingClaim` | Persistent volume existingClaim | `""` |
| `compact.persistentVolume.size` | Persistent volume size | `2Gi` |
| `compact.persistentVolume.storageClass` | Persistent volume storage class name | `""` |
| `ruler.replicaCount` |  for ruler | `1` |
| `ruler.updateStrategy` | StatefulSet update strategy | `type: RollingUpdate` |
| `ruler.image.repository` | Docker image repo for ruler | `quay.io/thanos/thanos` |
| `ruler.image.tag` | Docker image tag for ruler | `v0.7.0` |
| `ruler.image.pullPolicy` | Docker image pull policy for ruler | `IfNotPresent` |
| `ruler.additionalLabels` | Additional labels on ruler pod| `{}` |
| `ruler.additionalAnnotations` | Additional annotations on ruler pod| `{}` |
| `service.querier.type` | Service type for the querier | `ClusterIP` |
| `service.querier.http.port` | Service http port for the querier  | `9090` |
| `service.querier.grpc.port` | Service grpc port for the querier  | `10901` |
| `service.storeGateway.type` | Service type for the store gateway | `ClusterIP` |
| `service.storeGateway.http.port` | Service http port for the store gateway | `9090` |
| `service.storeGateway.grpc.port` | Service grpc port for the store gateway | `10901` |
| `service.ruler.type` | Service type for ruler | `ClusterIP` |
| `service.ruler.http.port` | Service http port for ruler | `9090` |
| `service.ruler.grpc.port` | Service grpc port for ruler | `10901` |
| `querier.logLevel` | querier log level | `info` |
| `querier.stores` | list of stores [see](https://github.com/thanos-io/thanos/blob/master/docs/components/query.md) | `[]` |
| `querier.additionalFlags` | additional command line flags | `{}` |
| `querier.livenessProbe.initialDelaySeconds` | liveness probe initialDelaySeconds | `30` |
| `querier.livenessProbe.periodSeconds` | liveness probe periodSeconds | `10` |
| `querier.livenessProbe.successThreshold` | liveness probe successThreshold | `1` |
| `querier.livenessProbe.timeoutSeconds` | liveness probe timeoutSeconds | `30` |
| `querier.readinessProbe.initialDelaySeconds` | readiness probe initialDelaySeconds | `30` |
| `querier.readinessProbe.periodSeconds` | readiness probe periodSeconds | `10` |
| `querier.readinessProbe.successThreshold` | readiness probe successThreshold | `1` |
| `querier.readinessProbe.timeoutSeconds` | readiness probe timeoutSeconds | `30` |
| `querier.resources` | Resources | `{}` |
| `querier.nodeSelector` | NodeSelector | `{}` |
| `querier.tolerations` | Tolerations | `[]` |
| `querier.affinity` | Affinity | `{}` |
| `querier.volumeMounts` | additional volume mounts | `nil` |
| `querier.volumes` | additional volumes | `nil` |
| `storeGateway.extraEnv` | extra env vars | `nil` |
| `storeGateway.logLevel` | store gateway log level | `info` |
| `storeGateway.indexCacheSize` | index cache size | `500MB` |
| `storeGateway.chunkPoolSize` | chunk pool size | `500MB` |
| `storeGateway.objStoreType` | object store [type](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `GCS` |
| `storeGateway.additionalFlags` | additional command line flags | `{}` |
| `storeGateway.objStoreConfig` | config for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `nil` |
| `storeGateway.livenessProbe.initialDelaySeconds` | liveness probe initialDelaySeconds | `30` |
| `storeGateway.livenessProbe.periodSeconds` | liveness probe periodSeconds | `10` |
| `storeGateway.livenessProbe.successThreshold` | liveness probe successThreshold | `1` |
| `storeGateway.livenessProbe.timeoutSeconds` | liveness probe timeoutSeconds | `30` |
| `storeGateway.readinessProbe.initialDelaySeconds` | readiness probe initialDelaySeconds | `30` |
| `storeGateway.readinessProbe.periodSeconds` | readiness probe periodSeconds | `10` |
| `storeGateway.readinessProbe.successThreshold` | readiness probe successThreshold | `1` |
| `storeGateway.readinessProbe.timeoutSeconds` | readiness probe timeoutSeconds | `30` |
| `storeGateway.resources` | Resources | `{}` |
| `storeGateway.nodeSelector` | NodeSelector | `{}` |
| `storeGateway.tolerations` | Tolerations | `[]` |
| `storeGateway.affinity` | Affinity | `{}` |
| `storeGateway.volumeMounts` | additional volume mounts | `nil` |
| `storeGateway.volumes` | additional volumes | `nil` |
| `storeGateway.persistentVolume.enabled` | persistent volume enabled | `enabled` |
| `storeGateway.persistentVolume.accessModes` | persistent volume accessModes | `[ReadWriteOnce]` |
| `storeGateway.persistentVolume.annotations` | persistent volume annotations | `{}` |
| `storeGateway.persistentVolume.existingClaim` | persistent volume existingClaim | `` |
| `storeGateway.persistentVolume.size` | persistent volume size | `2Gi` |
| `storeGateway.persistentVolume.storageClass` | Persistent volume storage class name | `""` |
| `compact.extraEnv` | extra env vars | `nil` |
| `compact.logLevel` | store gateway log level | `info` |
| `compact.retentionResolutionRaw` | retention for raw buckets | `30d` |
| `compact.retentionResolution5m` | retention for 5m buckets | `120d` |
| `compact.retentionResolution1h` | retention for 1h buckets | `10y` |
| `compact.consistencyDelay` | consistency delay | `30m` |
| `compact.objStoreType` | object store [type](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `GCS` |
| `compact.additionalFlags` | additional command line flags | `{}` |
| `compact.objStoreConfig` | config for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `nil` |
| `compact.resources` | Resources | `{}` |
| `compact.nodeSelector` | NodeSelector | `{}` |
| `compact.tolerations` | Tolerations | `[]` |
| `compact.affinity` | Affinity | `{}` |
| `compact.volumeMounts` | additional volume mounts | `nil` |
| `compact.volumes` | additional volumes | `nil` |
| `ruler.sidecar.image.repository` | Docker image for configmap watcher sidecar | `kiwigrid/k8s-configmap-watcher` |
| `ruler.sidecar.image.tag` | Docker image tag for configmap watcher sidecar | `0.1.0` |
| `ruler.sidecar.image.pullPolicy` | pull policy for configmap watcher sidecar | `IfNotPresent` |
| `ruler.sidecar.enabled` | enable configmap watcher sidecar | `false` |
| `ruler.sidecar.watchLabel` | label for configmaps to watch | `thanos_alert_config` |
| `ruler.extraEnv` | extra env vars | `nil` |
| `ruler.logLevel` | ruler log level | `info` |
| `ruler.evalInterval` | ruler evaluation interval | `1m` |
| `ruler.ruleFile` | rule files that should be used | `/etc/thanos-ruler/**/*-rules.yaml` |
| `ruler.alertmanagerUrl` | ruler alert manager url | `http://localhost` |
| `ruler.clusterName` | ruler cluster name | `nil` |
| `ruler.queries` | ruler quieries endpoints | `[]` |
| `ruler.objStoreType` | object store [type](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `GCS` |
| `ruler.additionalFlags` | additional command line flags | `{}` |
| `ruler.objStoreConfig` | config for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `nil` |
| `ruler.config` | default ruler config | `nil` |
| `ruler.resources` | Resources | `{}` |
| `ruler.nodeSelector` | NodeSelector | `{}` |
| `ruler.tolerations` | Tolerations | `[]` |
| `ruler.affinity` | Affinity | `{}` |
| `ruler.volumeMounts` | additional volume mounts | `nil` |
| `ruler.volumes` | additional volumes | `nil` |
| `ruler.persistentVolume.enabled` | persistent volume enabled | `enabled` |
| `ruler.persistentVolume.accessModes` | persistent volume accessModes | `[ReadWriteOnce]` |
| `ruler.persistentVolume.annotations` | persistent volume annotations | `{}` |
| `ruler.persistentVolume.existingClaim` | persistent volume existingClaim | `""` |
| `ruler.persistentVolume.size` | persistent volume size | `2Gi` |
| `ruler.persistentVolume.storageClass` | Persistent volume storage class name | `""` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install --name prometheus-thanos --set ingress.enabled=false kiwigrid/prometheus-thanos
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.
