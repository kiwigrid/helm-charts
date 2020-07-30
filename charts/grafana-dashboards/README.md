# grafana-dashboards

This charts will convert all Grafana dashboards saved as json file in the dashboards directory to a Kubernetes configmap, which can be consumed AUTOMATICALLY by the Grafana dashboard import sidecar.

See: <https://github.com/helm/charts/tree/master/stable/grafana#sidecar-for-dashboards>

| Parameter                  | Description                 | Default |
|----------------------------|-----------------------------|---------|
| `labels.grafana_dashboard` | set grafana_dashboard label | `"1"`   |
