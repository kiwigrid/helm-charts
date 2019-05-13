# Global Error Pages

## Introduction

This chart installs a controller for [Traefik](https://traefik.io/) global [error pages](https://docs.traefik.io/configuration/backends/kubernetes/#global-default-backend-ingresses). This service creates a global ingress rule which match all unmatched ingress rules. You can use any container you want. The container must expose the error page at the `/` path. The only error which is handled by traefik over this service by default is the `404` error.


## Prerequisites

-   Has been tested on Kubernetes 1.11+

## Installing the Chart

To install the chart with the release name `error-pages`, run the following command:

```bash
$ helm install kiwigrid/error-pages --name error-pages --values=my-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `error-pages` deployment:

```bash
$ helm delete error-pages
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge error-pages`

## Configuration

The following table lists the configurable parameters of the error-pages chart and their default values.

| Parameter                                  | Description                               | Default                            |
| ------------------------------------------ | ----------------------------------------- | ---------------------------------- |
| `replicaCount` | replica count | `1`|
| `updateStrategy` | Deployment update strategy | `type: RollingUpdate` |
| `image.repository` | Docker image repo | `guillaumebriday/traefik-custom-error-pages`|
| `image.tag` | Docker image tag | `latest`|
| `image.pullPolicy` | Docker image pull policy| `IfNotPresent`|
| `resources` | Resources | `{}`|
| `nodeSelector` | NodeSelector | `{}`|
| `tolerations` | Tolerations | `[]`|
| `affinity` | Affinity | `{}`|

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name error-pages --set ingress.enabled=false kiwigrid/error-pages
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.
