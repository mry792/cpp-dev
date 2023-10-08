#! /usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

source .env

docker exec -it ${CONTAINER_NAME} bash --login
