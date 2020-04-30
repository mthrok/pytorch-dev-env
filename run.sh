#!/usr/bin/env bash

image_name="${USER}-pytorch-dev-env"
work_dir="/scratch/${USER}/"
# Note:
# work_dir must have exact same permission as "$(id -u ${USER}):$(id -g ${USER}):",
# otherwise you cannot write anything from the container.

# --previleged is required for nvprof (you still need to sudo though)
# --shm-size is shared memory config and used by torch.utils.data.DataLoader
# https://github.com/pytorch/pytorch/issues/5040#issuecomment-379291662

docker run -d --runtime=nvidia \
       --init \
       --privileged \
       --shm-size=8G \
       -v "${work_dir}:${work_dir}" \
       -w "${work_dir}" \
       --name "${image_name}" \
       "${image_name}" sleep infinity

for config_dir in '.gitconfig' '.emacs.d' '.ssh'; do
    if [ -f ~/"${config_dir}" ]; then
	docker cp ~/"${config_dir}" "${image_name}:/home/${USER}"
    fi
done

docker exec -it "${image_name}" bash
