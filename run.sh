#!/usr/bin/env bash

image_name="${USER}-pytorch-dev-env"
work_dir="${HOME}/dev"
# Note:
# work_dir must have exact same permission as "$(id -u ${USER}):$(id -g ${USER}):",
# otherwise you cannot write anything from the container.

docker run -d --runtime=nvidia \
       --init \
       -v "${work_dir}:${work_dir}" \
       -w "${work_dir}" \
       --name "${image_name}" \
       "${image_name}" sleep infinity
docker exec -it "${image_name}" bash
