#!/usr/bin/env bash

image_name="${USER}-pytorch-dev-env"
work_dir="/scratch/${USER}/"
# Note:
# work_dir must have exact same permission as "$(id -u ${USER}):$(id -g ${USER}):",
# otherwise you cannot write anything from the container.

docker run -d --runtime=nvidia \
       --init \
       -v "${work_dir}:${work_dir}" \
       -w "${work_dir}" \
       --name "${image_name}" \
       "${image_name}" sleep infinity

if [ -f ~/.gitconfig ]; then
    docker cp ~/.gitconfig "${image_name}:/home/${USER}"
fi

if [ -d ~/.emacs.d ]; then
    docker cp ~/.emacs.d "${image_name}:/home/${USER}"
fi

docker exec -it "${image_name}" bash
