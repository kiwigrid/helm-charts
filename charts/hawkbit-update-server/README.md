# Hawkbit update server (DEPRECATED!)

## THIS CHART IS DEPRECATED AS WAS MOVED TO:
* https://github.com/eclipse/packages/tree/master/charts/hawkbit

## Introduction

[Eclipse hawkBit™](https://www.eclipse.org/hawkbit/) is a domain independent back-end framework for rolling out software updates to constrained edge devices as well as more powerful controllers and gateways connected to IP based networking infrastructure.

This chart uses hawkbit/hawkbit-update-server container to run Hawkbit update server inside Kubernetes.

## Prerequisites

- Has been tested on Kubernetes 1.11+

## Installing the Chart

To install the chart with the release name `hawkbit-update-server`, run the following command:

```bash
helm install kiwigrid/hawkbit-update-server --name hawkbit-update-server
```

## Uninstalling the Chart

To uninstall/delete the `hawkbit-update-server` deployment:

```bash
helm delete hawkbit-update-server
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge hawkbit-update-server`

## Configuration

The following table lists the configurable parameters of the hawkbit-update-server chart and their default values.

| Parameter                                  | Description                               | Default                            |
| ------------------------------------------ | ----------------------------------------- | ---------------------------------- |
| `image.repository`                         | Docker image repo                         | `hawkbit/hawkbit-update-server`    |
| `image.tag`                                | Docker image                              | `0.3.0M5-mysql`                    |
| `image.pullPolicy`                         | Docker image pull policy                  | `IfNotPresent`                     |
| `image.pullSecrets`                        | Docker image pull secrets                 | `{}`                               |
| `service.annotations`                      | Service annotations                       | `{}`                               |
| `service.type`                             | Service type                              | `ClusterIP`                        |
| `service.port`                             | Service port of hawkbit-update-server UI  | `80`                               |
| `resources`                                | Resource limits for the pod               | `{}`                               |
| `podTemplate.annotations`                  | pod annotations                           | `{}`                               |
| `ingress.enabled`                          | Ingress enabled                           | `false`                            |
| `ingress.annotations`                      | Ingress annotations                       | `{}`                               |
| `ingress.path`                             | Ingress path                              | `/`                                |
| `ingress.hosts`                            | Ingress hosts                             | `[]`                               |
| `ingress.tls`                              | Ingress TLS                               | `[]`                               |
| `resources`                                | Resources                                 | `{}`                               |
| `nodeSelector`                             | NodeSelector                              | `{}`                               |
| `tolerations`                              | Tolerations                               | `[]`                               |
| `affinity`                                 | Affinity                                  | `{}`                               |
| `useActuatorCheck`                         | use actuator for health checks            | `false`                            |
| `livenessProbe.initialDelaySeconds`        | livenessProbe initialDelaySeconds         | `240`                              |
| `livenessProbe.timeoutSeconds`             | livenessProbe timeoutSeconds              | `5`                                |
| `readinessProbe.initialDelaySeconds`       | readinessProbe timeoutSeconds             | `120`                              |
| `readinessProbe.timeoutSeconds`            | readinessProbe timeoutSeconds             | `5`                                |
| `env.springDatasourceHost`                 | MySQL host                                | `"hawkbit-update-server-mysql"`    |
| `env.springDatasourceDb`                   | MySQL db                                  | `"hawkbit"`                        |
| `env.springRabbitmqHost`                   | RabbitMq host                             | `"hawkbit-update-server-rabbitmq"` |
| `env.springRabbitmqUsername`               | RabbitMq user                             | `"hawkbit"`                        |
| `env.springRabbitmqPassword`               | RabbitMq pass                             | `"hawkbit"`                        |
| `oidc.enabled`                             | enable OpenID Connect authentication      | `false`                            |
| `oidc.clientId`                            | OpenID Connect client ID                  | `""`                               |
| `oidc.clientSecret`                        | OpenID Connect client secret              | `""`                               |
| `oidc.issuerUri`                           | OpenID Connect issuer URI                 | `""`                               |
| `oidc.authorizationUri`                    | OpenID Connect authorization URI          | `""`                               |
| `oidc.tokenUri`                            | OpenID Connect token URI                  | `""`                               |
| `oidc.userInfoUri`                         | OpenID Connect user info URI              | `""`                               |
| `oidc.jwkSetUri`                           | OpenID Connect JWK set URI                | `""`                               |
| `extraEnv`                                 | Optional environment variables            | `{}`                               |
| `extraVolumes`                             | list of extra volumes                     | `[]`                               |
| `extraVolumeMounts`                        | list of extra volume mounts               | `[]`                               |
| `config.application`                       | yaml formated config for spring           | `see values file`                  |
| `config.secrets`                           | yaml formated config for spring secrets   | `see values file`                  |
| `configMap.mountPath`                      | config map mount path (should by application path inside docker +) | `{}`      |
| `spring.profiles`                          | Spring profile                            | `"mysql"`                          |
| `config.application.hawkbit.dmf.hono.enabled` | Enable Hono                           | `false`                             |
| `config.application.hawkbit.dmf.hono.tenant-list-uri` | tenant list uri | `"http://[DEVICE_REGISTRY_HOST]:8080/admin/tenants"` |
| `config.application.hawkbit.dmf.hono.device-list-uri` | device list uri  | `"http://[DEVICE_REGISTRY_HOST]:8080/admin/$$tenantId/devices"` |
| `config.application.hawkbit.dmf.hono.credentials-list-uri` | credentials list uri | `"http://[DEVICE_REGISTRY_HOST]:8080/v1/credentials/$$tenantId/$$deviceId"` |
| `config.application.hawkbit.dmf.hono.authentication-method` | auth method              | `"oidc"`                           |
| `config.application.hawkbit.dmf.hono.username` | hono username                         | `"[KEYCLOAK_HAWKBIT_USERNAME]"`    |
| `config.application.hawkbit.dmf.hono.oidc-token-uri` | oidc token uri |  `"http://[KEYCLOAK_HOST]:8080/auth/realms/kiwigrid/protocol/openid-connect/token"` |
| `config.application.hawkbit.dmf.hono.oidc-client-id` | oidc client id                  | `"[KEYCLOAK_DEVICE_REGISTRY_CLIENT_ID]"` |
| `config.application.spring.cloud.stream.bindings.default.group` | bindings default group | `"hawkbit"`                      |
| `config.application.spring.cloud.stream.bindings.device-created.destination` | device created destination | `"device-registry.device-created"` |
| `config.application.spring.cloud.stream.bindings.device-updated.destination` | device updated destination | `"device-registry.device-updated"` |
| `config.application.spring.cloud.stream.bindings.device-deleted.destination` | device deleted destination | `"device-registry.device-deleted"` |
| `config.application.spring.security.user.name` | Hawkbit login username                | `admin`                            |
| `secrets.hawkbit.dmf.hono.password`        | Hono password                             | `"[KEYCLOAK_HAWKBIT_USER_PASSWORD]"` |  
| `secrets.spring.security.user.password`    | Hawkbit login password (the "{noop}" prefix is needed!) | `"{noop}admin"`      |
| `secrets.spring.datasource.username`       | Mysql user                                | `hawkbit`                          |
| `secrets.spring.datasource.password`       | MySql password                            | `hawkbit`                          |
| `mysql.enabled`                            | use MySQL dependency chart                | `true`                             |
| `mysql.mysqlUser`                          | MySQL User                                | `hawkbit`                          |
| `mysql.mysqlPassword`                      | MySQL password                            | `hawkbit`                          |
| `mysql.mysqlDatabase`                      | MySQL db                                  | `hawkbit`                          |
| `mysql.metrics.enabled`                    | use MySQL Prometheus metrics              | `true`                             |
| `rabbitmq.enabled`                         | use Rabbitmq dependency chart             | `true`                             |
| `rabbitmq.rabbitmq.username`               | Rabbitmq username                         | `hawkbit`                          |
| `rabbitmq.rabbitmq.password`               | Rabbitmq password                         | `hawkbit`                          |
| `rabbitmq.rabbitmq.metrics.enabled`        | use Rabbitmq Prometheus metrics           | `true`                             |  
| `podDisruptionBudget.enabled`              | PodDisruptionBudget enabled               | `false`                            |
| `podDisruptionBudget.minAvailable`         | PodDisruptionBudget min. available pods   | `1`                                |
| `updateStrategy`                           | Deployment strategy to replace old pods   | `type: Recreate`                   |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install --name hawkbit-update-server --set ingress.enabled=false kiwigrid/hawkbit-update-server
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.
