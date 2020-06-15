# InfluxDB-Backup

## Introduction

This Helm chart is able to backup multiple InfluxDB instances and upload it to a storage provider like Google or Azure storage.
It's influenced by backup function of the [official InfluxDB chart](https://github.com/influxdata/helm-charts/tree/master/charts/influxdb).
Parts of this Readme are copied from there.

## InfluxDB is an Open-Source Time Series Database

[InfluxDB](https://github.com/influxdata/influxdb) is an open source time series database built by the folks over at [InfluxData](https://influxdata.com) with no external dependencies. It's useful for recording metrics, events, and performing analytics.

## QuickStart

```bash
helm repo add kiwigrid https://kiwigrid.github.io
helm upgrade --install influxdb-backup kiwigrid/influxdb-backup --namespace influxdb-backup
```

## Prerequisites

- Kubernetes 1.4+
- PV provisioner support in the underlying infrastructure (optional)

## Installing the Chart

To install the chart with the release name `influxdb-backup`:

```bash
helm upgrade --install influxdb-backup kiwigrid/influxdb-backup
```

The command deploys InfluxDB-backup on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `influxdb-backup` cronjob:

```bash
helm uninstall influxdb-backup
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

| Parameter | Description | Default |
|---|---|---|
| image.repository | Image repository url | influxdb |
| image.tag | Image tag | 1.7.10-alpine |
| image.pullPolicy | Image pull policy | IfNotPresent |
| image.pullSecrets | It will store the repository's credentials to pull image | nil |
| persistence.enabled | Boolean to enable and disable persistance | true |
| persistence.existingClaim | An existing PersistentVolumeClaim, ignored if enterprise.enabled=true | nil |
| persistence.storageClass | If set to "-", storageClassName: "", which disables dynamic provisioning. If undefined (the default) or set to null, no storageClassName spec is set, choosing the default provisioner.  (gp2 on AWS, standard on GKE, AWS & OpenStack |  |
| persistence.annotations | Annotations for volumeClaimTemplates | nil |
| persistence.accessMode | Access mode for the volume | ReadWriteOnce |
| persistence.size | Storage size | 8Gi |
| `backup.instances`                                | InfluxDB instances to backup                                                                                                                                                     | `[]`                                            |
| `backup.directory`                                | directory where backups are stored in                                                                                                                                                     | `"/backups"`                                            |
| `backup.retentionDays`                            | retention time in days for backups (older backups are deleted)                                                                                                                            | `10`                                                    |
| `backup.cronjob.schedule`                         | crontab style time schedule for backup execution                                                                                                                                          | `"0 2 * * *"`                                           |
| `backup.cronjob.historyLimit`                     | cronjob historylimit                                                                                                                                                                      | `3`                                                     |
| `backup.cronjob.annotations`                      | backup pod annotations                                                                                                                                                                    | `{}`                                                    |
| `backup.uploadProviders.google.enabled`           | enable upload to google storage bucket                                                                                                                                                    | `false`                                                 |
| `backup.uploadProviders.google.secret`            | json secret whith serviceaccount data to access Google storage bucket                                                                                                                     | `""`                                                    |
| `backup.uploadProviders.google.secretKey`         | service account secret key name                                                                                                                                                           | `"key.json"`                                            |
| `backup.uploadProviders.google.existingSecret`    | Name of existing secret object with Google serviceaccount json credentials                                                                                                                | `""`                                                    |
| `backup.uploadProviders.google.bucketName`        | google storage bucket name name                                                                                                                                                           | `"gs://bucket/influxdb"`                                |
| `backup.uploadProviders.google.image.registry`    | Google Cloud SDK image registry                                                                                                                                                           | `docker.io`                                             |
| `backup.uploadProviders.google.image.repository`  | Google Cloud SDK image name                                                                                                                                                               | `google/cloud-sdk`                              |
| `backup.uploadProviders.google.image.tag`         | Google Cloud SDK image tag                                                                                                                                                                | `291.0.0-alpine`                                            |
| `backup.uploadProviders.azure.enabled`            | enable upload to azure storage container                                                                                                                                                  | `false`                                                 |
| `backup.uploadProviders.azure.secret`             | secret whith credentials to access Azure storage                                                                                                                                          | `""`                                                    |
| `backup.uploadProviders.azure.secretKey`          | service account secret key name                                                                                                                                                           | `"connection-string"`                                   |
| `backup.uploadProviders.azure.existingSecret`     | Name of existing secret object                                                                                                                                                            | `""`                                                    |
| `backup.uploadProviders.azure.containerName`      | destination container                                                                                                                                                                     | `"influxdb-container"`                                  |
| `backup.uploadProviders.azure.image.registry`     | Azure CLI image registry                                                                                                                                                                  | `docker.io`                                             |
| `backup.uploadProviders.azure.image.repository`   | Azure CLI image name                                                                                                                                                                      | `microsoft/azure-cli`                                     |
| `backup.uploadProviders.azure.image.tag`          | Azure CLI image tag                                                                                                                                                                       | `2.0.24`                                            |
| `backup.restore.enabled` | Enables restore (disables backup) | `false` |
| `backup.restore.download` | Enabled download of backups from configured storage provider  | `false` |
| `backup.restore.db` | Name of the database which should be restored | `"database"` |
| `backup.restore.directory` | Directory in the backup container from which the backup is restored  | `"/backups/instancename/dbname/20200530_020027"` |
| `backup.restore.host` | InfluxDB host to restore to | `"influxdb.influxdb.svc.cluster.local"` |

The [full image documentation](https://hub.docker.com/_/influxdb/) contains more information about running InfluxDB in docker.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm upgrade --install my-release --set persistence.enabled=true,persistence.size=200Gi kiwigrid/influxdb-backup
```

The above command enables persistence and changes the size of the requested data volume to 200GB.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm upgrade --install influxdb-backuOne can create a job from the backup cronjob on demand as follows:p -f values.yaml kiwigrid/influxdb-backup
```

## Persistence

The image stores data in the `/backup` directory in the container.

If persistence is enabled, a [Persistent Volume](http://kubernetes.io/docs/user-guide/persistent-volumes/) associated with the Cronjob will be provisioned. The volume is created using dynamic volume provisioning. In case of a disruption e.g. a node drain, kubernetes ensures that the same volume will be reatached to the Pod, preventing any data loss. Althought, when persistence is not enabled, influxdb-backup data will be stored in an empty directory thus, in a Pod restart, data will be lost.

## Backing up and restoring

Before proceeding, please read [Backing up and restoring in InfluxDB OSS](https://docs.influxdata.com/influxdb/v1.7/administration/backup_and_restore/). While the chart offers backups by means of the [`cronjob`](./templates/cronjob.yaml), restores do not fall under the chart's scope today but can be achieved by one-off kubernetes jobs.

### Backups

When enabled, the[`backup-cronjob`](./templates/cronjob-backup.yaml) runs on the configured schedule. One can create a job from the backup cronjob on demand as follows:

```sh
kubectl create job --from=cronjobs/influxdb-backup influxdb-backup-$(date +%Y%m%d%H%M%S)
```

### Restores

When enabled, the [`restore-cronjob`](./templates/cronjob-backup.yaml) runs on the configured schedule. One can create a job from the backup cronjob on demand as follows:

```sh
kubectl -n influxdb create job --from=cronjobs/influxdb-backup influxdb-restore-$(date +%Y%m%d%H%M%S)
```

Be aware that if the restore is enabled the backup is disabled, so you can only restore OR backup. Therefore after a restore you have to redeploy the chart with restore option disabled to create backups again.
