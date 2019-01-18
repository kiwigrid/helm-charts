# Zipkins Stackdriver Proxy

- **Source:** https://github.com/openzipkin/zipkin-gcp

## Introduction

This chart forwards zipkin traces to stackdriver.

## Installing the Chart

Install from remote URL with the release name `zipkin-stackdriver-proxy` into namespace `default`:

```console
$ helm upgrade -i zipkin-stackdriver-proxy kiwigrid/zipkin-stackdriver-proxy
```

## Uninstalling the Chart

To uninstall/delete the `zipkin-stackdriver-proxy` deployment:

```console
$ helm delete zipkin-stackdriver-proxy --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                         | Description                             | Default                                                                                     |
| --------------------------------- | --------------------------------------  | ---------------------------------------------------------                                   |
| `image.repository`                           | image name                        | `gcr.io/stackdriver-trace-docker/zipkin-collector`                                                        |
| `image.tag`                        | image tag                      | `v0.6.0`                                                                                      |
| `image.pullPolicy`                 | Image pull policy                       | `IfNotPresent`                                                                              |
| `resources`                    | Resource limits for pod             | `{}`                                   |
| `nodeSelector`                 | NodeSelector                                 | `{}`                                   |
| `tolerations`                  | Tolerations                                  | `[]`                                   |
| `affinity`                     | Affinity                                     | `{}`                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kiwigrid/zipkin-stackdriver-proxy
```

> **Tip**: You can use the default [values.yaml](values.yaml)
