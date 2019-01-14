# Kubernetes Policy Controller

- **Source:** https://github.com/open-policy-agent/kubernetes-policy-controller

## Introduction

This chart creates a Kubernetes Policy Controller deployment on a Kubernetes cluster using the Helm package manager.

See also the docs for [Kubernetes Policy Controller](https://github.com/open-policy-agent/kubernetes-policy-controller).


## Installing the Chart

Install from remote URL with the release name `kubernetes-policy-controller` into namespace `opa`:

```console
$ helm upgrade -i kubernetes-policy-controller kiwigrid/kubernetes-policy-controller --namespace opa
```

## Uninstalling the Chart

To uninstall/delete the `kubernetes-policy-controller` deployment:

```console
$ helm delete kubernetes-policy-controller --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the kubernetes policy chart controller and their default values.

| Parameter                         | Description                             | Default                                                                                     |
| --------------------------------- | --------------------------------------  | ---------------------------------------------------------                                   |
| `opa.image`                           | opa image                          | `openpolicyagent/opa`                                                        |
| `opa.imageTag`                        | opa image tag                      | `0.10.1`                                                                                      |
| `opa.imagePullPolicy`                 | Image pull policy                       | `IfNotPresent`                                                                              |
| `kubeMgmt.image`                           | kube mgmt image                          | `openpolicyagent/kube-mgmt`                                                        |
| `kubeMgmt.imageTag`                        | kube mgmt image tag                      | `0.6`                                                                                      |
| `kubeMgmt.imagePullPolicy`                 | Image pull policy                       | `IfNotPresent`                                                                              |
| `kubernetesPolicyController.image`                           | opa image                          | `nikhilbh/kubernetes-policy-controller`                                                        |
| `kubernetesPolicyController.imageTag`                        | gcp service account controller image tag                      | `1.2`                                                                                      |
| `kubernetesPolicyController.imagePullPolicy`                 | Image pull policy                       | `IfNotPresent`                                                                              |
| `admissionControllerKind`                  | admission controller kind           | `MutatingWebhookConfiguration` |
| `admissionControllerFailurePolicy`                  | admission controller failure policy           | `Ignore` |
| `generateAdmissionControllerCerts`                  | auto generate admission controller certs          | `true` |
| `admissionControllerCA`                  | admission controller ca only used if generateAdmissionControllerCerts is `false`        |  |
| `admissionControllerCert`                  | admission controller cert only used if generateAdmissionControllerCerts is `false`         |  |
| `admissionControllerKey`                  | admission controller key only used if generateAdmissionControllerCerts is `false`         |  |
| `admissionControllerRules`                  | admission controller rules         |  |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml kiwigrid/kubernetes-policy-controller
```

> **Tip**: You can use the default [values.yaml](values.yaml)