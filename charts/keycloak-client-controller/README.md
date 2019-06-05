# Keycloak Client Controller

The [Keycloak Client Controller](https://github.com/kiwigrid/keycloak-client-controller) manages clients in
a [Keycloak](https://www.keycloak.org) instance via Kubernetes resources.

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                 | Description                                                | Default                               |
| ------------------------- | ---------------------------------------------------------- | ------------------------------------- |
| `image.repository`        | keycloak-client-controller image                           | `kiwigrid/keycloak-client-controller` |
| `image.tag`               | keycloak-client-controller image tag                       | `0.1.0`                               |
| `image.pullPolicy`        | Image pull policy                                          | `IfNotPresent`                        |
| `keycloak.url`            | URL of the Keycloak instance where clients will be managed | `http://localhost:8080/auth/`         |
| `keycloak.user`           | Name of the Keycloak admin user                            | `admin`                               |
| `keycloak.pwd`            | Password of the Keycloak admin user                        | `admin`                               |
| `resources`               | Resources                                                  | `{}`                                  |
| `nodeSelector`            | NodeSelector                                               | `{}`                                  |
| `tolerations`             | Tolerations                                                | `[]`                                  |
| `affinity`                | Affinity                                                   | `{}`                                  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kiwigrid/keycloak-client-controller
```

> **Tip**: You can use the default [values.yaml](values.yaml)
