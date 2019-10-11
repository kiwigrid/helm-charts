# Kiwigrid Helm charts

[![CircleCI](https://img.shields.io/circleci/project/github/kiwigrid/helm-charts/master.svg?style=plastic)](https://circleci.com/gh/kiwigrid/helm-charts)

## Add repo

```console
$ helm repo add kiwigrid https://kiwigrid.github.io
```

## Installation
### IBM IKS

For IBM IKS path `/var/log/pods` must be mounted, otherwise only kubelet logs would be available

```yaml
extraVolumeMounts: |
    - name: pods
      mountPath: /var/log/pods
      readOnly: true

extraVolumes: |
    - name: pods
      hostPath:
        path: "/var/log/pods"
        type: Directory
```

## Support

* Please don't write mails directly to the maintainers.
* Use the Github issue tracker instead.

## Adding charts

* Use a fork of this repo
* Always sign your commits (git commit -s -m 'usefull commitmessage')
* Do NOT touch default (master) branch in any forks
* Always create new branches to work on
* Create a Github pull request and fill out the PR template
* Follow Helm best practices: [https://docs.helm.sh/chart_best_practices](https://docs.helm.sh/chart_best_practices)
