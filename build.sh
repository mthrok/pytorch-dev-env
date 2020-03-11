#!/usr/bin/env bash

set -euxo pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )"

image_name="${USER}-pytorch-dev-env"
docker build \
       --build-arg USERNAME="${USER}" \
       --build-arg UID="$(id -u ${USER})" \
       --build-arg GID="$(id -g ${USER})"  \
       -t "${image_name}" .
