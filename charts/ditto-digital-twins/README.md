# This chart is deprecated. Ditto is now maintained within the [Eclipse Packages project](https://github.com/eclipse/packages/tree/master/charts/ditto)

## Introduction

[Eclipse Ditto™](https://www.eclipse.org/ditto/) is a technology in the IoT implementing a software pattern called “digital twins”.
A digital twin is a virtual, cloud based, representation of his real world counterpart (real world “Things”, e.g. devices like sensors, smart heating, connected cars, smart grids, EV charging stations, …).

This chart uses `eclipse/ditto-XXX` containers to run Ditto inside Kubernetes.

## Motivation

This chart is based on the [Eclipse Ditto Helm chart](https://github.com/eclipse/ditto/tree/master/deployment/helm).
Unfortunately the referenced chart is not available in a Helm registry.
This is the main reason why we decided to provide our own chart.
Furthermore we want to cover some other points:

* Enhance flexibility
* Enable Prometheus support
* Usage of dedicated ServiceAccount
* PodDisruptionBudget
* Ingress
* OIDC support w/o manual change of nginx config

## Prerequisites

* Has been tested on Kubernetes 1.11+

## Installing the Chart

To install the chart with the release name `ditto-digital-twins`, run the following command:

```bash
helm install kiwigrid/ditto-digital-twins --name ditto-digital-twins
```

## Uninstalling the Chart

To uninstall/delete the `ditto-digital-twins` deployment:

```bash
helm delete ditto-digital-twins
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

> **Tip**: To completely remove the release, run `helm delete --purge ditto-digital-twins`

## Configuration

Please view the `values.yaml` for the list of possible configuration values with its documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
helm install --name ditto-digital-twins --set swaggerui.enabled=false kiwigrid/ditto-digital-twins
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart.

## Configuration Examples

### OpenID Connect (OIDC)

To enable OIDC authentiaction adjust following properties:

```yaml
global:
  jwtOnly: true

gateway:
  enableDummyAuth: false
  systemProps:
    - "-Dditto.gateway.authentication.oauth.openid-connect-issuers.myprovider=openid-connect.onelogin.com/oidc"
```

### Securing Devops Resource

To secure /devops and /status resource adjust configuration to (username will be `devops`):

```yaml
gateway:
  enableDummyAuth: false
  devopsSecureStatus: true
  devopsPassword: foo
  statusPassword: bar
``
