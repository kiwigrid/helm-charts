# Stackdriver Exporter

- **Source:** https://github.com/frodenas/stackdriver_exporter

## Introduction

This chart is for the stackdriver exporter.

## Installing the Chart

Install from remote URL with the release name `stackdriver-exporter` into namespace `default`:

```console
helm upgrade -i stackdriver-exporter kiwigrid/stackdriver-exporter
```

## Uninstalling the Chart

To uninstall/delete the `stackdriver-exporter` deployment:

```console
helm delete stackdriver-exporter --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                         | Description                             | Default                                                                                     |
| --------------------------------- | --------------------------------------  | ---------------------------------------------------------                                   |
| `image.repository`                           | image name                        | `frodenas/stackdriver-exporter`                                                        |
| `image.tag`                        | image tag                      | `v0.6.0`                                                                                      |
| `image.pullPolicy`                 | Image pull policy                       | `IfNotPresent`                                                                              |
| `web.port`                    | listen port                          | `9255`                                               |
| `web.path`                    | Path under which to expose Prometheus metrics                          | `/metrics`                                               |
| `gcp.projectId`                    | gcp project id                          |                                                        |
| `gcp.serviceAccountName`                    | name of service account for gcp                          |                                                        |
| `gcp.keyfileSecretName`                    | name of secret                          |                                                        |
| `gcp.metricsTypePrefixes`          | list of metric prefixes                                     |             |
| `gcp.metricsInterval`          | Metric's timestamp interval to request from the Google Stackdriver Monitoring Metrics API. Only the most recent data point is used                                     | `5m`            |
| `gcp.metricsOffset`          | Offset (into the past) for the metric's timestamp interval to request from the Google Stackdriver Monitoring Metrics API, to handle latency in published metrics                                     | `0s`            |
| `gcpCredentials`          | gcp key file base64 encoded has only be set if `usingGCPController` is `false`                    |             |
| `usingGCPController`          | if true the secret will be created via a crd (see [Gcp Service Account Controller](https://github.com/kiwigrid/gcp-serviceaccount-controller) for more infos)                                     | `false`             |
| `resources`                    | Resource limits for pod             | `{}`                                   |
| `nodeSelector`                 | NodeSelector                                 | `{}`                                   |
| `tolerations`                  | Tolerations                                  | `[]`                                   |
| `affinity`                     | Affinity                                     | `{}`                                   |
| `prometheusScrapeSlow`         | Enables prometheus.io/scrape-slow annotation | `false`                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml kiwigrid/stackdriver-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)
