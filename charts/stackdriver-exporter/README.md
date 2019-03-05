# Stackdriver Exporter

- **Source:** https://github.com/frodenas/stackdriver_exporter

## Introduction

This chart is for the stackdriver exporter.

## Installing the Chart

Install from remote URL with the release name `stackdriver-exporter` into namespace `default`:

```console
$ helm upgrade -i stackdriver-exporter kiwigrid/stackdriver-exporter
```

## Uninstalling the Chart

To uninstall/delete the `stackdriver-exporter` deployment:

```console
$ helm delete stackdriver-exporter --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                         | Description                             | Default                                                                                     |
| --------------------------------- | --------------------------------------  | ---------------------------------------------------------                                   |
| `image.repository`                           | image name                        | `kiwigrid/stackdriver-exporter`                                                        |
| `image.tag`                        | image tag                      | `10`                                                                                      |
| `image.pullPolicy`                 | Image pull policy                       | `IfNotPresent`                                                                              |
| `gcp.projectId`                    | gcp project id                          |                                                        |
| `gcp.metricsTypePrefixes`          | list of metric prefixes                                     |             |
| `resources`                    | Resource limits for pod             | `{}`                                   |
| `nodeSelector`                 | NodeSelector                                 | `{}`                                   |
| `tolerations`                  | Tolerations                                  | `[]`                                   |
| `affinity`                     | Affinity                                     | `{}`                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kiwigrid/stackdriver-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)
