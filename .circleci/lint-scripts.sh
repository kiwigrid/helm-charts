#!/usr/bin/env sh
#
# lint bash scripts
#

set -o errexit
set -o pipefail

CONFIG_DIR="./.circleci"
REPO_ROOT="$(git rev-parse --show-toplevel)"

find "${REPO_ROOT}/${CONFIG_DIR}" -type f -name "*.sh" -exec echo lint {}\; -exec shellcheck -x {} \;
