# A Helm Chart for any Kind of Resources

The purpose of this chart is to become able to manage every installed resources in a Kubernetes cluster via HELM.

For example:
  * Global secrets (e.g. TLS certs or `imagePullSecrets`)
  * ConfigMaps (e.g. grafana-dashboards, see https://github.com/helm/charts/tree/master/stable/grafana#sidecar-for-dashboards)
  * Custom Resources (e.g. `GcpNamespaceRestriction`, see https://github.com/kiwigrid/gcp-serviceaccount-controller)

## Example

Create a file called `custom-values.yaml` with following content:
```yaml
anyResources:
  myPullSecret: |-
    apiVersion: v1
    data:
      .dockercfg: eyJodHRwczovL215LmRvY2tlci5yZWdpc3RyeSI6eyJ1c2VybmFtZSI6ImRvY2tlciIsInBhc3N3b3JkIjoidW5rbm93biIsImF1dGgiOiJFaWsxYWhrdXVzaG9ocGhpdWY5emFocGhlZVRoYXhhPSJ9fQo=
    kind: Secret
    metadata:
      name: myPullSecret
    type: kubernetes.io/dockercfg
```

Install
```console
helm upgrade --install my-pull-secret --values custom-values.yaml kiwigrid/any-resource
```

## Open Issue

* HELM standard label support
