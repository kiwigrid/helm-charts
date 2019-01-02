#!/usr/bin/env bash
#
# lint bash scripts
#

set -o errexit
set -o pipefail

CONFIG_DIR="./.circleci"

find "${CONFIG_DIR}" -type f -name "*.sh" -exec echo lint {}\; -exec shellcheck -x {} \;
