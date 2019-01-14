# Prometheus Pingdom Exporter

- **Source:** https://github.com/giantswarm/prometheus-pingdom-exporter

[prometheus-pingdom-exporter](https://github.com/giantswarm/prometheus-pingdom-exporter) the prometheus-pingdom-exporter cares about preprocessing the pingdom uptime check results for consumption of by prometheus.

## Introduction

This chart creates a kubernetes deployment on a Kubernetes cluster using the Helm package manager.

## Installing the Chart

Install from remote URL with the release name `prometheus-pingdom-exporter` into namespace `monitoring`:

```console
$ helm upgrade -i prometheus-pingdom-exporter kiwigrid/prometheus-pingdom-exporter --namespace monitoring
```

## Uninstalling the Chart

To uninstall/delete the `my-release-name` deployment:

```console
$ helm delete my-release-name --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the prometheus-pingdom-exporter chart and their default values.

| Parameter                      | Description                             | Default                                                                                     |
| ------------------------------ | --------------------------------------  | ---------------------------------------------------------                                   |
| `image.repository`             | Image                                      | `gcr.io/google-containers/fluentd-elasticsearch`           |
| `image.tag`                    | Image tag                                  | `v2.3.2`                                                   |
| `image.pullPolicy`             | Image pull policy                          | `IfNotPresent`                                             |
| `service.type`                 | Service type                                 | `ClusterIP`                            |
| `service.port`                 | Service port of Graphite UI                  | `8080`                                 |
| `service.annotations`          | Service annotations                          | `{}`                                   |
| `service.labels`               | Service labels                               | `{}`                                   |
| `resources.limits.cpu`         | CPU limit                                  | `100m`                                                     |
| `resources.limits.memory`      | Memory limit                               | `500Mi`                                                    |
| `resources.requests.cpu`       | CPU request                                | `100m`                                                     |
| `resources.requests.memory`    | Memory request                             | `200Mi`                                                    |
| `nodeSelector`                 | NodeSelector                                 | `{}`                                   |
| `tolerations`                  | Tolerations                                  | `[]`                                   |
| `affinity`                     | Affinity                                     | `{}`                                   |
| `pingdom.user`                 | Username of the Pingdom Account | `somebody@invalid` |
| `pingdom.password`             | Password of the Pingdom Account | `totallysecret` |
| `pingdom.appId`                | Application ID, can be created on the pingdom website | `alsototallysecret` |
| `pingdom.accountEmail`         | Account-E-Mail of the Account owner | `somebodyorelse@invalid` |
| `pingdom.wait`                 | time (in seconds) between accessing the Pingdom  API | `10` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kiwigrid/prometheus-pingdom-exporter
```

> **Tip**: You can use the default [values.yaml](values.yaml)
