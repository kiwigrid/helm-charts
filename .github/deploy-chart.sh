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
# needed for github actions as home dir would be /github/home/ otherwise
HOME="/home/gkh"

# ssh config
mkdir -p /home/gkh/.ssh
echo "${SSH_PRIVATE_KEY}" > /home/gkh/.ssh/id_rsa
chmod 600 /home/gkh/.ssh/id_rsa
ssh-keyscan github.com >> /home/gkh/.ssh/known_hosts

# get kiwigrid.github.io
test -d "${REPO_ROOT}"/"${REPO_DIR}" && rm -rf "${REPO_ROOT:=?}"/"${REPO_DIR:=?}"
git clone "${CHART_REPO}" "${REPO_ROOT}"/"${REPO_DIR}"

# get not builded charts
while read -r FILE; do
  echo "check file ${FILE}"
  if [ ! -f "${REPO_ROOT}/${REPO_DIR}/$(yq r - name < "${FILE}")-$(yq r - version < "${FILE}").tgz" ]; then
    echo "append chart ${FILE}"
    CHARTS="${CHARTS} $(yq r - name < "${FILE}")"
  fi
done < <(find "${REPO_ROOT}/${CHART_DIR}" -maxdepth 2 -mindepth 2 -type f -name "[Cc]hart.yaml")

if [ -z "${CHARTS}" ]; then
  echo "no chart changes... so no chart build and upload needed... exiting..."
  exit 0
fi

# set original file dates
(
cd "${REPO_ROOT}"/"${REPO_DIR}" || exit
while read -r FILE; do
  ORG_FILE_TIME=$(git log --pretty=format:%cd --date=format:'%y%m%d%H%M' "${FILE}" | tail -n 1)
  echo "set original time ${ORG_FILE_TIME} to ${FILE}"
  touch -c -t "${ORG_FILE_TIME}" "${FILE}"
done < <(git ls-files charts)
)

# preserve dates in index.yaml by moving old charts and index out of the repo before packaging the new version
mkdir -p "${REPO_ROOT}"/"${TMP_DIR}"
mv "${REPO_ROOT}"/"${REPO_DIR}"/index.yaml "${REPO_ROOT}"/"${TMP_DIR}" || true
mv "${REPO_ROOT}"/"${REPO_DIR}"/*.tgz "${REPO_ROOT}"/"${TMP_DIR}"

#add helm repos
if ! helm repo list | grep -q "^stable"; then
  helm repo add stable https://kubernetes-charts.storage.googleapis.com
fi
helm repo add kiwigrid https://kiwigrid.github.io
helm repo update

# build helm dependencies for all charts
find "${REPO_ROOT}"/"${CHART_DIR}" -mindepth 1 -maxdepth 1 -type d -exec helm dependency build {} \;

# package only changed charts
for CHART in ${CHARTS}; do
  echo "building ${CHART} chart..."
  helm package "${REPO_ROOT}"/"${CHART_DIR}"/"${CHART}" --destination "${REPO_ROOT}"/"${REPO_DIR}"
done

# Create index and merge with previous index which contains the non-changed charts
helm repo index --merge "${REPO_ROOT}"/"${TMP_DIR}"/index.yaml --url https://"${REPO_DIR}" "${REPO_ROOT}"/"${REPO_DIR}"

# move old charts back into git repo
mv "${REPO_ROOT}"/"${TMP_DIR}"/*.tgz "${REPO_ROOT}"/"${REPO_DIR}"

# push changes to github
cd "${REPO_ROOT}"/"${REPO_DIR}"
git config --global user.email "ci@kiwigrid-robot.com"
git config --global user.name "kiwigrid-ci-bot"
git add --all .
git commit -m "Push Kiwigrid charts via Github action build nr. ${GITHUB_RUN_NUMBER}"
git push --set-upstream origin master
