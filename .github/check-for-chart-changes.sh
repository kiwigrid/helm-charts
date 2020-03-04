#!/bin/bash
#
# check for chart changes to speedup ci
#

set -o errexit
set -o pipefail

echo "Check for chart changes to speedup ci..."

CHART_CHANGES="$(git diff --find-renames --name-only "$(git rev-parse --abbrev-ref HEAD)" remotes/origin/master -- charts)"

if [ -z "${CHART_CHANGES}" ]; then
  echo -e "\n\n Error! No chart changes detected! Exiting... \n"
  exit 1
else
  echo -e "\nChanges found in:"
  echo "${CHART_CHANGES}"
  echo -e "\nContinue with next job... \n"
fi
