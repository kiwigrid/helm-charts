# Spring Cloud Config Server

## Introduction

Spring Cloud Config Server is a normal Spring Boot application, it can be configured through all the ways a Spring Boot application can be configured.  You may use environment variables or you can mount configuration in the provided volume.  The configuration file must be named **application** and may be a properties or yaml file. See the [Spring Boot documentation](http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config) for further information on how to use and configure Spring Boot.

## Prerequisites

-   Has been tested on Kubernetes 1.11+

## Installing the Chart

To install the chart with the release name `spring-cloud-config-server`, run the following command:

```bash
$ helm install kiwigrid/spring-cloud-config-server --name spring-cloud-config-server
```

## Uninstalling the Chart

To uninstall/delete the `spring-cloud-config-server` deployment:

```bash
$ helm delete spring-cloud-config-server
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge spring-cloud-config-server`

## Configuration

The following table lists the configurable parameters of the spring-cloud-config-server chart and their default values.

| Parameter                                  | Description                               | Default                            |
| ------------------------------------------ | ----------------------------------------- | ---------------------------------- |
| `image.repository`                         | Docker image repo                         | `hyness/spring-cloud-config-server`|
| `image.tag`                                | Docker image                              | `2.1.3.RELEASE`                    |
| `image.pullPolicy`                         | Docker image pull policy                  | `IfNotPresent`                     |
| `image.pullSecrets`                        | Docker image pull secrets                 | `{}`                               |
| `service.type`                             | Service type                              | `ClusterIP`                        |
| `service.port`                             | Service port of spring-cloud-config-server| `80`                               |
| `resources`                                | Resource limits for the pod               | `{}`                               |
| `ingress.enabled`                          | Ingress enabled                           | `false`                            |
| `ingress.annotations`                      | Ingress annotations                       | `{}`                               |
| `podTemplate.annotations`                  | Pod template annotations                  | `{}`                               |
| `ingress.path`                             | Ingress path                              | `/`                                |
| `ingress.hosts`                            | Ingress hosts                             | `[]`                               |
| `ingress.tls`                              | Ingress TLS                               | `[]`                               |
| `resources`                                | Resources                                 | `{}`                               |
| `nodeSelector`                             | NodeSelector                              | `{}`                               |
| `tolerations`                              | Tolerations                               | `[]`                               |
| `affinity`                                 | Affinity                                  | `{}`                               |
| `extraEnv`                                 | extra Env                                 | `[]`                               |
| `config.gitUri`                            | git repo URL                              | `{}`                               |
| `config.gitSearchpath`                     | git search path                           | `{application}`                    |
| `secrets.gitUsername`                      | git username                              | `{}`                               |
| `secrets.gitPassword`                      | git password                              | `{}`                               |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name spring-cloud-config-server --set ingress.enabled=false kiwigrid/spring-cloud-config-server
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.
