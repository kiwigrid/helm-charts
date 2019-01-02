#!/usr/bin/env sh
#
# lint charts
#

set -o errexit
set -o pipefail

CONFIG_DIR=".circleci"
GIT_REPO="https://github.com/kiwigrid/helm-charts"

git remote add k8s "${GIT_REPO}"
git fetch k8s master
ct lint --config="${CONFIG_DIR}"/ct.yaml --lint-conf="${CONFIG_DIR}"/lintconf.yaml --chart-yaml-schema="${CONFIG_DIR}"/chart_schema.yaml
