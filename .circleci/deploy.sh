#!/usr/bin/env bash
#
# deploy kiwigrid chart to kiwigrid.github.io
#

set -o errexit
set -o pipefail

CHART_DIR="charts"
CHART_REPO="git@github.com:kiwigrid/kiwigrid.github.io.git"
REPO_DIR="kiwigrid.github.io"
REPO_ROOT="$(git rev-parse --show-toplevel)"

if [ "${CIRCLECI}" == 'true' ] && [ -z "${CIRCLE_PULL_REQUEST}" ]; then

  # get kiwigrid.github.io
  test -d "${REPO_ROOT}"/"${REPO_DIR}" && rm -rf "${REPO_ROOT:=?}"/"${REPO_DIR:=?}"
  git clone "${CHART_REPO}" "${REPO_ROOT}"/"${REPO_DIR}"

  # build helm dependencies & chart
  find "${REPO_ROOT}"/"${CHART_DIR}" -type d -exec helm dependency build {} \; -exec helm package {} --destination "${REPO_ROOT}"/"${REPO_DIR}" \;

  helm repo index --merge "${REPO_ROOT}"/"${REPO_DIR}"/index.yaml --url https://${REPO_DIR} "${REPO_ROOT}"/"${REPO_DIR}"

  # push changes to github
  cd "${REPO_ROOT}"/"${REPO_DIR}"
  git config --global user.email "CircleCi@circleci.com"
  git config --global user.name "Circle CI"
  git add --all .
  git commit -m "push kiwigrid charts via circleci build nr: ${CIRCLE_BUILD_NUM}"
  git push --set-upstream origin master
else
  echo "skipped deploy as only master is deployed..."
fi
