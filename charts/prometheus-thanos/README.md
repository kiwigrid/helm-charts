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

## Using Sidecar Configmap Watcher

To enable the sidecar you can set `ruler.sidecar.enabled` to `true`. The sidcar will then watch all configmaps and if there is a configmap with label named like `ruler.sidecar.watchLabel` the sidecar will use the contents inside the config directory of the ruler and will notify the ruler to reload the config files.

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

## Upgrading

This section describes instructions on how to upgrade from a previous version of this chart and breaking changes.

### 3.x

There was a breaking change in version 3.0.0 which removed the `storeGateway.indexCacheSize` setting in favour of a `storeGateway.indexCache` config object.
If you're upgrading from a pre-3.0.0 version of this chart, your config needs to adapt the new format.

For example, if you had previously set `storeGateway.indexCacheSize` to `500MB`, you need to set `storeGateway.indexCache` to the following:

```yaml
indexCache:
  type: IN-MEMORY
  config:
    max_size: 500MB
```
All configuration options can be found in [the documentation](https://thanos.io/components/store.md/#index-cache).

### 4.x

The compactor persistence is now enabled by default and the default PVC size was raised to 10GB.

## Configuration

The following table lists the configurable parameters of the prometheus-thanos chart and their default values.

| Parameter                                  | Description                               | Default                            |
| ------------------------------------------ | ----------------------------------------- | ---------------------------------- |
| `bucketWebInterface.enabled` | Controls whether bucket web interface related resources should be created | `false` |
| `bucketWebInterface.additionalAnnotations` | Additional annotations on bucket web interface pods| `{}` |
| `bucketWebInterface.additionalFlags` | Additional command line flags | `{}` |
| `bucketWebInterface.additionalLabels` | Additional labels on bucket web interface pods| `{}` |
| `bucketWebInterface.affinity` | Affinity | `{}` |
| `bucketWebInterface.extraEnv` | Extra env vars | `nil` |
| `bucketWebInterface.httpServerPort` | The port to expose from the bucket web interface container | `10902` |
| `bucketWebInterface.image.repository` | Docker image repo for bucket web interface | `quay.io/thanos/thanos` |
| `bucketWebInterface.image.tag` | Docker image tag for bucket web interface | `v0.12.0` |
| `bucketWebInterface.image.pullPolicy` | Docker image pull policy for bucket web interface| `IfNotPresent` |
| `bucketWebInterface.serviceAccount.create` | Create service account | `true` |
| `bucketWebInterface.serviceAccount.annotations` | Service account annotations | `nil` |
| `bucketWebInterface.logLevel` | Bucket web interface log level | `info` |
| `bucketWebInterface.nodeSelector` | NodeSelector | `{}` |
| `bucketWebInterface.objStoreType` | Object store [type](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `nil` |
| `bucketWebInterface.objStoreConfig` | Config for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `{}` |
| `bucketWebInterface.objStoreConfigFile` | Path to config file for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md). Either this or `objStoreType` + `objStoreConfig`. | `nil` |
| `bucketWebInterface.podNumericalPriorityEnabled` | Enables use of the `podPriority`. Either this or `podPriorityClassName`. | `false` |
| `bucketWebInterface.podPriority` | Numerical value of the pod priority. Enabled by `podNumericalPriorityEnabled` | `0` |
| `bucketWebInterface.podPriorityClassName` | Name of the pod priority class to use. Either this or `podNumericalPriorityEnabled` | `""` |
| `bucketWebInterface.replicaCount` | Replica count for bucket web interface | `1` |
| `bucketWebInterface.resources` | Resources | `{}` |
| `bucketWebInterface.tolerations` | Tolerations | `[]` |
| `bucketWebInterface.updateStrategy` | Deployment update strategy | `type: RollingUpdate` |
| `bucketWebInterface.volumeMounts` | Additional volume mounts | `nil` |
| `bucketWebInterface.volumes` |Additional volumes | `nil` |
| `compact.enabled` | Controls whether compact related resources should be created | `true` |
| `compact.additionalAnnotations` | Additional annotations on compactor pod| `{}` |
| `compact.additionalFlags` | Additional command line flags | `{}` |
| `compact.additionalLabels` | Additional labels on compactor pod| `{}` |
| `compact.affinity` | Affinity | `{}` |
| `compact.consistencyDelay` | Consistency delay | `30m` |
| `compact.extraEnv` | Extra env vars | `nil` |
| `compact.image.repository` | Docker image repo for store gateway | `quay.io/thanos/thanos` |
| `compact.image.tag` | Docker image tag for store gateway | `v0.12.0` |
| `compact.image.pullPolicy` | Docker image pull policy for store gateway | `IfNotPresent` |
| `compact.serviceAccount.create` | Create service account | `true` |
| `compact.serviceAccount.annotations` | Service account annotations | `nil` |
| `compact.logLevel` | Store gateway log level | `info` |
| `compact.nodeSelector` | NodeSelector | `{}` |
| `compact.objStoreConfig` | Config for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `{}` |
| `compact.objStoreConfigFile` | Path to config file for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md). Either this or `objStoreType` + `objStoreConfig`. | `nil` |
| `compact.objStoreType` | Object store [type](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `nil` |
| `compact.persistentVolume.enabled` | Persistent volume enabled | `true` |
| `compact.persistentVolume.accessModes` | Persistent volume accessModes | `[ReadWriteOnce]` |
| `compact.persistentVolume.annotations` | Persistent volume annotations | `{}` |
| `compact.persistentVolume.existingClaim` | Persistent volume existingClaim | `""` |
| `compact.persistentVolume.size` | Persistent volume size | `10Gi` |
| `compact.persistentVolume.storageClass` | Persistent volume storage class name | `""` |
| `compact.podNumericalPriorityEnabled` | Enables use of the `podPriority`. Either this or `podPriorityClassName`. | `false` |
| `compact.podPriority` | Numerical value of the pod priority. Enabled by `podNumericalPriorityEnabled` | `0` |
| `compact.podPriorityClassName` | Name of the pod priority class to use. Either this or `podNumericalPriorityEnabled` | `""` |
| `compact.resources` | Resources | `{}` |
| `compact.retentionResolutionRaw` | Retention for raw buckets | `30d` |
| `compact.retentionResolution5m` | Retention for 5m buckets | `120d` |
| `compact.retentionResolution1h` | Retention for 1h buckets | `10y` |
| `compact.tolerations` | Tolerations | `[]` |
| `compact.updateStrategy` | StatefulSet update strategy | `type: RollingUpdate` |
| `compact.volumeMounts` | Additional volume mounts | `nil` |
| `compact.volumes` | Additional volumes | `nil` |
| `querier.enabled` | Controls whether querier related resources should be created | `true` |
| `querier.additionalAnnotations` | Additional annotations on querier pods| `{}` |
| `querier.additionalFlags` | Additional command line flags | `{}` |
| `querier.additionalLabels` | Additional labels on querier pods| `{}` |
| `querier.affinity` | Affinity | `{}` |
| `querier.autoscaling.enabled` | Controls whether StoreGateway autoscaling is enabled | `false` |
| `querier.autoscaling.maxReplicas` | Maximum number of replicas to scale to | `10` |
| `querier.autoscaling.minReplicas` | Minimum number of replicas to scale to | `1` |
| `querier.autoscaling.metrics` | Array of MetricSpecs that will decide whether to scale in or out | `target of 80% for both CPU and memory resources` |
| `querier.image.repository` | Docker image repo for querier | `quay.io/thanos/thanos` |
| `querier.image.tag` | Docker image tag for querier | `v0.12.0` |
| `querier.image.pullPolicy` | Docker image pull policy for querier| `IfNotPresent` |
| `querier.serviceAccount.create` | Create service account | `true` |
| `querier.serviceAccount.annotations` | Service account annotations | `nil` |
| `querier.livenessProbe.initialDelaySeconds` | Liveness probe initialDelaySeconds | `30` |
| `querier.livenessProbe.periodSeconds` | Liveness probe periodSeconds | `10` |
| `querier.livenessProbe.successThreshold` | Liveness probe successThreshold | `1` |
| `querier.livenessProbe.timeoutSeconds` | Liveness probe timeoutSeconds | `30` |
| `querier.logLevel` | Querier log level | `info` |
| `querier.nodeSelector` | NodeSelector | `{}` |
| `querier.podNumericalPriorityEnabled` | Enables use of the `podPriority`. Either this or `podPriorityClassName`. | `false` |
| `querier.podPriority` | Numerical value of the pod priority. Enabled by `podNumericalPriorityEnabled` | `0` |
| `querier.podPriorityClassName` | Name of the pod priority class to use. Either this or `podNumericalPriorityEnabled` | `""` |
| `querier.readinessProbe.initialDelaySeconds` | Readiness probe initialDelaySeconds | `30` |
| `querier.readinessProbe.periodSeconds` | Readiness probe periodSeconds | `10` |
| `querier.readinessProbe.successThreshold` | Readiness probe successThreshold | `1` |
| `querier.readinessProbe.timeoutSeconds` | Readiness probe timeoutSeconds | `30` |
| `querier.replicaCount` | Replica count for querier | `1` |
| `querier.resources` | Resources | `{}` |
| `querier.stores` | List of stores [see](https://github.com/thanos-io/thanos/blob/master/docs/components/query.md) | `[]` |
| `querier.tolerations` | Tolerations | `[]` |
| `querier.updateStrategy` | Deployment update strategy | `type: RollingUpdate` |
| `querier.volumeMounts` | Additional volume mounts | `nil` |
| `querier.volumes` | Additional volumes | `nil` |
| `ruler.enabled` | controls whether ruler related resources should be created | `true` |
| `ruler.additionalAnnotations` | Additional annotations on ruler pod| `{}` |
| `ruler.additionalFlags` | Additional command line flags | `{}` |
| `ruler.additionalLabels` | Additional labels on ruler pod| `{}` |
| `ruler.affinity` | Affinity | `{}` |
| `ruler.alertmanagerUrl` | Ruler alert manager url | `http://localhost` |
| `ruler.clusterName` | Ruler cluster name | `nil` |
| `ruler.config` | Default ruler config | `nil` |
| `ruler.evalInterval` | Ruler evaluation interval | `1m` |
| `ruler.extraEnv` | Extra env vars | `nil` |
| `ruler.image.repository` | Docker image repo for ruler | `quay.io/thanos/thanos` |
| `ruler.image.tag` | Docker image tag for ruler | `v0.12.0` |
| `ruler.image.pullPolicy` | Docker image pull policy for ruler | `IfNotPresent` |
| `ruler.serviceAccount.annotations` | Service account annotations | `nil` |
| `ruler.livenessProbe.initialDelaySeconds` | Liveness probe initialDelaySeconds | `30` |
| `ruler.livenessProbe.periodSeconds` | Liveness probe periodSeconds | `10` |
| `ruler.livenessProbe.successThreshold` | Liveness probe successThreshold | `1` |
| `ruler.livenessProbe.timeoutSeconds` | Liveness probe timeoutSeconds | `30` |
| `ruler.logLevel` | Ruler log level | `info` |
| `ruler.nodeSelector` | NodeSelector | `{}` |
| `ruler.objStoreType` | Object store [type](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `nil` |
| `ruler.objStoreConfig` | Config for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `{}` |
| `ruler.objStoreConfigFile` | Path to config file for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md). Either this or `objStoreType` + `objStoreConfig`. | `nil` |
| `ruler.persistentVolume.enabled` | Persistent volume enabled | `true` |
| `ruler.persistentVolume.accessModes` | Persistent volume accessModes | `[ReadWriteOnce]` |
| `ruler.persistentVolume.annotations` | Persistent volume annotations | `{}` |
| `ruler.persistentVolume.existingClaim` | Persistent volume existingClaim | `""` |
| `ruler.persistentVolume.size` | Persistent volume size | `2Gi` |
| `ruler.persistentVolume.storageClass` | Persistent volume storage class name | `""` |
| `ruler.podNumericalPriorityEnabled` | Enables use of the `podPriority`. Either this or `podPriorityClassName`.| `false` |
| `ruler.podPriority` | Numerical value of the pod priority. Enabled by `podNumericalPriorityEnabled` | `0` |
| `ruler.podPriorityClassName` | Name of the pod priority class to use. Either this or `podNumericalPriorityEnabled` | `""` |
| `ruler.queries` | Ruler quieries endpoints | `[]` |
| `ruler.readinessProbe.initialDelaySeconds` | Readiness probe initialDelaySeconds | `30` |
| `ruler.readinessProbe.periodSeconds` | Readiness probe periodSeconds | `10` |
| `ruler.readinessProbe.successThreshold` | Readiness probe successThreshold | `1` |
| `ruler.readinessProbe.timeoutSeconds` | Readiness probe timeoutSeconds | `30` |
| `ruler.replicaCount` |  Replica count for ruler | `1` |
| `ruler.resources` | Resources | `{}` |
| `ruler.ruleFile` | Rule files that should be used | `/etc/thanos-ruler/**/*-rules.yaml` |
| `ruler.sidecar.image.repository` | Docker image for configmap watcher sidecar | `kiwigrid/k8s-configmap-watcher` |
| `ruler.sidecar.image.tag` | Docker image tag for configmap watcher sidecar | `0.1.1` |
| `ruler.sidecar.image.pullPolicy` | Pull policy for configmap watcher sidecar | `IfNotPresent` |
| `ruler.sidecar.enabled` | Enable configmap watcher sidecar | `false` |
| `ruler.sidecar.watchLabel` | Label for configmaps to watch | `thanos_alert_config` |
| `ruler.tolerations` | Tolerations | `[]` |
| `ruler.updateStrategy` | StatefulSet update strategy | `type: RollingUpdate` |
| `ruler.volumeMounts` | Additional volume mounts | `nil` |
| `ruler.volumes` | Additional volumes | `nil` |
| `service.bucketWebInterface.type` | Service type for the bucket web interface | `ClusterIP` |
| `service.bucketWebInterface.http.port` | Service http port for the bucket web interface  | `9090` |
| `service.bucketWebInterface.annotations` | Service annotations for the bucket web interface  | `{}` |
| `service.querier.type` | Service type for the querier | `ClusterIP` |
| `service.querier.http.port` | Service http port for the querier  | `9090` |
| `service.querier.grpc.port` | Service grpc port for the querier  | `10901` |
| `service.querier.annotations` | Service annotations for the querier  | `{}` |
| `service.storeGateway.type` | Service type for the store gateway | `ClusterIP` |
| `service.storeGateway.http.port` | Service http port for the store gateway | `9090` |
| `service.storeGateway.grpc.port` | Service grpc port for the store gateway | `10901` |
| `service.storeGateway.annotations` | Service annotations for the store gateway | `{}` |
| `service.ruler.type` | Service type for ruler | `ClusterIP` |
| `service.ruler.http.port` | Service http port for ruler | `9090` |
| `service.ruler.grpc.port` | Service grpc port for ruler | `10901` |
| `service.ruler.annotations` | Service annotations for the ruler | `{}` |
| `storeGateway.enabled` | Controls whether StoreGateway related resources should be created | `true` |
| `storeGateway.affinity` | Affinity | `{}` |
| `storeGateway.additionalAnnotations` | Additional annotations on store gateway pods| `{}` |
| `storeGateway.additionalFlags` | Additional command line flags | `{}` |
| `storeGateway.additionalLabels` | Additional labels on store gateway pods| `{}` |
| `storeGateway.autoscaling.enabled` | Controls whether StoreGateway autoscaling is enabled | `false` |
| `storeGateway.autoscaling.maxReplicas` | Maximum number of replicas to scale to | `10` |
| `storeGateway.autoscaling.minReplicas` | Minimum number of replicas to scale to | `1` |
| `storeGateway.autoscaling.metrics` | Array of MetricSpecs that will decide whether to scale in or out | `target of 80% for both CPU and memory resources` |
| `storeGateway.disableIndexHeader` | Whether or not to disable [binary index headers](https://thanos.io/proposals/201912_thanos_binary_index_header.md/) | `false` |
| `storeGateway.chunkPoolSize` | Chunk pool size | `500MB` |
| `storeGateway.extraEnv` | Extra env vars | `nil` |
| `storeGateway.image.repository` | Docker image repo for store gateway | `quay.io/thanos/thanos` |
| `storeGateway.image.tag` | Docker image tag for store gateway | `v0.12.0` |
| `storeGateway.image.pullPolicy` | Docker image pull policy for store gateway | `IfNotPresent` |
| `storeGateway.indexCache.config` | Config for the index cache, see [the docs](https://thanos.io/components/store.md/#index-cache) | `max_size: 500MB` |
| `storeGateway.indexCache.type` | Type of the index cache, either `IN-MEMORY` or `MEMCACHED` | `IN-MEMORY` |
| `storeGateway.livenessProbe.initialDelaySeconds` | Liveness probe initialDelaySeconds | `30` |
| `storeGateway.livenessProbe.periodSeconds` | Liveness probe periodSeconds | `10` |
| `storeGateway.livenessProbe.successThreshold` | Liveness probe successThreshold | `1` |
| `storeGateway.livenessProbe.timeoutSeconds` | Liveness probe timeoutSeconds | `30` |
| `storeGateway.logLevel` | Store gateway log level | `info` |
| `storeGateway.nodeSelector` | NodeSelector | `{}` |
| `storeGateway.objStoreConfig` | Config for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `{}` |
| `storeGateway.objStoreConfigFile` | Path to config file for the [bucket store](https://github.com/thanos-io/thanos/blob/master/docs/storage.md). Either this or `objStoreType` + `objStoreConfig`. | `nil` |
| `storeGateway.objStoreType` | Object store [type](https://github.com/thanos-io/thanos/blob/master/docs/storage.md) | `GCS` |
| `storeGateway.persistentVolume.enabled` | Persistent volume enabled | `true` |
| `storeGateway.persistentVolume.accessModes` | Persistent volume accessModes | `[ReadWriteOnce]` |
| `storeGateway.persistentVolume.annotations` | Persistent volume annotations | `{}` |
| `storeGateway.persistentVolume.existingClaim` | Persistent volume existingClaim | `""` |
| `storeGateway.persistentVolume.size` | Persistent volume size | `2Gi` |
| `storeGateway.persistentVolume.storageClass` | Persistent volume storage class name | `""` |
| `storeGateway.podNumericalPriorityEnabled` | Enables use of the `podPriority`. Either this or `podPriorityClassName`. | `false` |
| `storeGateway.podPriority` | Numerical value of the pod priority. Enabled by `podNumericalPriorityEnabled` | `0` |
| `storeGateway.podPriorityClassName` | Name of the pod priority class to use. Either this or `podNumericalPriorityEnabled` | `""` |
| `storeGateway.readinessProbe.initialDelaySeconds` | Readiness probe initialDelaySeconds | `30` |
| `storeGateway.readinessProbe.periodSeconds` | Readiness probe periodSeconds | `10` |
| `storeGateway.readinessProbe.successThreshold` | Readiness probe successThreshold | `1` |
| `storeGateway.readinessProbe.timeoutSeconds` |Readiness probe timeoutSeconds | `30` |
| `storeGateway.replicaCount` | Replica count for store gateway | `1` |
| `storeGateway.resources` | Resources | `{}` |
| `storeGateway.serviceAccount.create` | Create service account | `true` |
| `storeGateway.serviceAccount.annotations` | Service account annotations | `nil` |
| `storeGateway.tolerations` | Tolerations | `[]` |
| `storeGateway.updateStrategy` | StatefulSet update strategy | `type: RollingUpdate` |
| `storeGateway.volumeMounts` | Additional volume mounts | `nil` |
| `storeGateway.volumes` |Additional volumes | `nil` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install --name prometheus-thanos --set ingress.enabled=false kiwigrid/prometheus-thanos
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.
