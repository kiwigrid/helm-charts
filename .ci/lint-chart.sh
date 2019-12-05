#!/bin/sh
#
# lint charts
#

set -o errexit
set -x

CONFIG_DIR=".ci"
GIT_REPO="https://github.com/kiwigrid/helm-charts"
REPO_ROOT="$(git rev-parse --show-toplevel)"

git remote add k8s "${GIT_REPO}"
git fetch k8s master

CHART="$(git diff --find-renames --name-only $(git rev-parse --abbrev-ref HEAD) remotes/k8s/master -- charts | head -n 1 | sed -e 's#charts/##g' -e 's#/[cC]hart.yaml##g')"

ct lint --config="${REPO_ROOT}/${CONFIG_DIR}"/ct.yaml \
  --lint-conf="${REPO_ROOT}/${CONFIG_DIR}"/lintconf.yaml \
  --chart-yaml-schema="${REPO_ROOT}/${CONFIG_DIR}"/chart_schema.yaml \
  --charts="${CHART}"

