# Keycloak Client Controller

The [Keycloak Controller](https://github.com/kiwigrid/keycloak-controller) manages clients and realms in one
or more [Keycloak](https://www.keycloak.org) instances via Kubernetes resources.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                 | Description                                                | Default                               |
| ------------------------- | ---------------------------------------------------------- | ------------------------------------- |
| `replicaCount`            | Number of replicas                                         | 1                                     |
| `image.repository`        | keycloak-controller image                                  | `kiwigrid/keycloak-controller`        |
| `image.tag`               | keycloak-controller image tag                              | `1.4.1`                               |
| `image.pullPolicy`        | Image pull policy                                          | `IfNotPresent`                        |
| `rbac.enabled`            | Controls RBAC usage                                        | `true`                                |
| `retryRate`               | Configure retry interval for failed resources              | `60s`                                 |
| `prometheus.enabled`      | Enables Prometheus scrape configuration                    | `true`                                |
| `prometheus.path`         | Metric endpoint                                            | `/endpoints/prometheus`               |
| `prometheus.port`         | Scrape port                                                | `8080`                                |
| `prometheus.step`         | How frequently to report metrics                           | `PT5s`                                |
| `prometheus.descriptions` | If meter descriptions should be sent to Prometheus         | `true`                                |
| `javaToolOptions`         | Allows to specify the initialization of tools              | see `values.yaml`                     |
| `gcpLogging`              | Enables Stackdriver conform logging                        | `true`                                |
| `namespaced`              | Controls whether watching only for events in its namespace | `true`                                |
| `resources`               | Resources                                                  | `{}`                                  |
| `nodeSelector`            | NodeSelector                                               | `{}`                                  |
| `tolerations`             | Tolerations                                                | `[]`                                  |
| `affinity`                | Affinity                                                   | `{}`                                  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install --name my-release -f values.yaml kiwigrid/keycloak-controller
```

> **Tip**: You can use the default [values.yaml](values.yaml)
