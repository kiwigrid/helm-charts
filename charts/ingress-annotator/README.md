# Ingress Annotator

## Introduction

[Ingress Annotator](https://github.com/kiwigrid/ingress-annotator/) supports annotating ingresses globaly or per namespace. This can be used for example for [traefik error pages](https://docs.traefik.io/configuration/commons/#custom-error-pages).

## Prerequisites

-   Has been tested on Kubernetes 1.11+

## Installing the Chart

To install the chart with the release name `ingress-annotator`, run the following command:

```bash
$ helm install kiwigrid/ingress-annotator --name ingress-annotator --values=my-values.yaml
```

## Uninstalling the Chart

To uninstall/delete the `ingress-annotator` deployment:

```bash
$ helm delete ingress-annotator
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge ingress-annotator`

## Configuration

The following table lists the configurable parameters of the ingress-annotator chart and their default values.

| Parameter                                  | Description                               | Default                            |
| ------------------------------------------ | ----------------------------------------- | ---------------------------------- |
| `image.repository` | Docker image repo | `kiwigrid/ingress-annotator`|
| `image.tag` | Docker image tag | `0.1.0`|
| `image.pullPolicy` | Docker image pull policy | `IfNotPresent`|
| `resources` | Resources | `{}`|
| `nodeSelector` | NodeSelector | `{}`|
| `tolerations` | Tolerations | `[]`|
| `affinity` | Affinity | `{}`|
| `config` | configuration [see](https://github.com/kiwigrid/ingress-annotator/) for more infos | `{}`|


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name ingress-annotator --set ingress.enabled=false kiwigrid/ingress-annotator
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.
