#!/bin/bash
#
# lint bash scripts
#

set -o errexit
set -o pipefail

CONFIG_DIR="./.circleci"

TMP_FILE="$(mktemp)"

find "${CONFIG_DIR}" -type f -name "*.sh" > "${TMP_FILE}"

while read -r FILE; do
  echo lint "${FILE}"
  shellcheck -x "${FILE}"
done < "${TMP_FILE}"

rm "${TMP_FILE}"
