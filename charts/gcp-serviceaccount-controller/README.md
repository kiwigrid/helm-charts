# Gcp Service Account Controller

- **Source:** https://github.com/kiwigrid/gcp-serviceaccount-controller

[gcp-serviceaccount-controller](https://github.com/kiwigrid/gcp-serviceaccount-controller) The Gcp service account controller creates services accounts and handles the roles and the secrets for kubernetes.

## Introduction

This chart creates a kubernetes controller deployment on a Kubernetes cluster using the Helm package manager.

See also the docs for [service account mangement](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
and [key management](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

## Installing the Chart

Install from remote URL with the release name `gcp-account-controller` into namespace `infra`:

```console
$ helm upgrade -i gcp-account-controller kiwigrid/gcp-serviceaccount-controller --namespace infra \
    --set gcpCredentials="$(cat service-account.json | base64)"
```

## Uninstalling the Chart

To uninstall/delete the `my-release-name` deployment:

```console
$ helm delete my-release-name --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the GCP serviceaccount chart and their default values.

| Parameter                 | Description                              | Default                                                                                                                                       |
| ------------------------- | -----------------------------------------| --------------------------------------------------------------------------------------------------------------------------------------------- |
| `image.repository`        | gcp service account controller image     | `kiwigrid/gcp-serviceaccount-controller`                                                                                                      |
| `image.tag`               | gcp service account controller image tag | `0.2.4`                                                                                                                                       |
| `image.pullPolicy`        | Image pull policy                        | `IfNotPresent`                                                                                                                                |
| `gcpCredentials`          | Service account key JSON file            | Should be provided and base64 encoded when installing the chart and no existing secret is used, in this case a new secret will be created holding this service account |
| `existingSecret`          | Existing secret containing the service account key JSON file | null|
| `existingSecretKey`       | The key to use within the existing secret            | "credentials.json" |
| `disableRestrictionCheck` | Disables namespace restriction           | `false`                                                                                                                                       |
| `resources`               | Resources                                | `{}`                                                                                                                                          |
| `nodeSelector`            | NodeSelector                             | `{}`                                                                                                                                          |
| `tolerations`             | Tolerations                              | `[]`                                                                                                                                          |
| `affinity`                | Affinity                                 | `{}`                                                                                                                                          |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kiwigrid/gcp-serviceaccount-controller
```

> **Tip**: You can use the default [values.yaml](values.yaml)
