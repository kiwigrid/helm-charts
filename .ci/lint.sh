#!/usr/bin/env bash
#
# Chart-testing lint
#

set -o errexit
set -o nounset
set -o pipefail

CHART_TESTING_IMAGE="quay.io/helmpack/chart-testing"
CHART_TESTING_TAG="v2.0.1"
REPO_ROOT="$(git rev-parse --show-toplevel)"
WORKDIR="/workdir"


docker run -it --rm -v "${REPO_ROOT}:${WORKDIR}" --workdir "${WORKDIR}" "${CHART_TESTING_IMAGE}:${CHART_TESTING_TAG}" ct lint --config="${WORKDIR}/.ci/ct-config.yaml" --lint-conf="${WORKDIR}/.ci/lint-config.yaml" --chart-yaml-schema="${WORKDIR}/.ci/chart-schema.yaml"
