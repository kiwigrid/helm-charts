# Secret Replicator

- **Source:** https://github.com/kiwigrid/secret-replicator

## Introduction

This chart distibutes existing secrets especially pull secrets across namespaces.

## Installing the Chart

Install from remote URL with the release name `secret-replicator` into namespace `default`:

```console
$ helm upgrade -i secret-replicator kiwigrid/secret-replicator
```

## Uninstalling the Chart

To uninstall/delete the `secret-replicator` deployment:

```console
$ helm delete secret-replicator --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                         | Description                             | Default                                                                                     |
| --------------------------------- | --------------------------------------  | ---------------------------------------------------------                                   |
| `image.repository`                           | image name                        | `kiwigrid/secret-replicator`                                                        |
| `image.tag`                        | image tag                      | `0.1.1`                                                                                      |
| `image.pullPolicy`                 | Image pull policy                       | `IfNotPresent`                                                                              |
| `image.pullSecrets`                  | Image pull secrets                              | `nil`                                                      |
| `secretList`                           | list of pull secrets                          | empty string                                                        |
| `ignoreNamespaces`             | namespaces which should be excluded from sync                                     | `kube-system,kube-pulic`               |
| `resources`                    | Resource limits for pod             | `{}`                                   |
| `nodeSelector`                 | NodeSelector                                 | `{}`                                   |
| `tolerations`                  | Tolerations                                  | `[]`                                   |
| `affinity`                     | Affinity                                     | `{}`                                   |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kiwigrid/secret-replicator
```

> **Tip**: You can use the default [values.yaml](values.yaml)
