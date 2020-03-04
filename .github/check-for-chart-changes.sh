#!/bin/bash
#
# check for chart changes to speedup ci
#

set -o errexit
set -o pipefail

echo "Check for chart changes to speedup ci..."

if [ -z "$(git diff --find-renames --name-only "$(git rev-parse --abbrev-ref HEAD)" remotes/origin/master -- charts)" ]; then
  echo -e "\n\n Error! No chart changes detected! Exiting... \n"
  exit 1
else
  echo -e "\n Changes found... Continue with next job... \n"
fi
