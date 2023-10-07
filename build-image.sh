#! /usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

export DOCKER_USER=$(id --user --name)
export DOCKER_UID=$(id --user)
export DOCKER_GID=$(id --group)

docker compose build
docker compose up --detach
