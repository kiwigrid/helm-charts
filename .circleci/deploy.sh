#!/bin/bash
#
# deploy kiwigrid charts to kiwigrid.github.io
#

set -o errexit
set -o pipefail

CHART_DIR="charts"
CHART_REPO="git@github.com:kiwigrid/kiwigrid.github.io.git"
REPO_DIR="kiwigrid.github.io"
REPO_ROOT="$(git rev-parse --show-toplevel)"
TMP_DIR="tmp"

if [ "${CIRCLECI}" == 'true' ] && [ -z "${CIRCLE_PULL_REQUEST}" ]; then

  if ! git diff --name-only HEAD~1 | grep -q 'charts\/.*\/[Cc]hart.yaml'; then
    echo "no chart changes... so no chart build and upload needed... exiting..."
    exit 0
  fi

  # get kiwigrid.github.io
  test -d "${REPO_ROOT}"/"${REPO_DIR}" && rm -rf "${REPO_ROOT:=?}"/"${REPO_DIR:=?}"
  git clone "${CHART_REPO}" "${REPO_ROOT}"/"${REPO_DIR}"

  # set original file dates
  (
  cd "${REPO_ROOT}"/"${REPO_DIR}" || exit
  while read -r FILE; do
    ORG_FILE_TIME=$(git log --pretty=format:%cd --date=format:'%y%m%d%H%M' "${FILE}" | tail -n 1)
    echo "set original time ${ORG_FILE_TIME} to ${FILE}"
    touch -c -t "${ORG_FILE_TIME}" "${FILE}"
  done < <(git ls-files)
  )

  # preserve dates in index.yaml by moving old charts and index out of the repo before packaging the new version
  mkdir -p "${REPO_ROOT}"/"${TMP_DIR}"
  mv "${REPO_ROOT}"/"${REPO_DIR}"/index.yaml "${REPO_ROOT}"/"${TMP_DIR}"
  mv "${REPO_ROOT}"/"${REPO_DIR}"/*.tgz "${REPO_ROOT}"/"${TMP_DIR}"

  # build helm dependencies & chart
  find "${REPO_ROOT}"/"${CHART_DIR}" -mindepth 1 -maxdepth 1 -type d -exec helm dependency build {} \; -exec helm package {} --destination "${REPO_ROOT}"/"${REPO_DIR}" \;

  # build repo index
  helm repo index --merge "${REPO_ROOT}"/"${TMP_DIR}"/index.yaml --url https://"${REPO_DIR}" "${REPO_ROOT}"/"${REPO_DIR}"

  # move old charts back into git repo
  mv "${REPO_ROOT}"/"${TMP_DIR}"/*.tgz "${REPO_ROOT}"/"${REPO_DIR}"

  # push changes to github
  cd "${REPO_ROOT}"/"${REPO_DIR}"
  git config --global user.email "CircleCi@circleci.com"
  git config --global user.name "Circle CI"
  git add --all .
  git commit -m "push kiwigrid charts via circleci build nr: ${CIRCLE_BUILD_NUM}"
  git push --set-upstream origin master
else
  echo "skipped deploy as only merged pr in master is deployed..."
fi
