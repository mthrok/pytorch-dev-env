#!/usr/bin/env bash

set -euxo pipefail

prefix="$1"
installer="Miniconda3-latest-Linux-x86_64.sh"

curl -sO https://repo.continuum.io/miniconda/"${installer}"
bash -x "${installer}" -b -p "${prefix}"
rm "${installer}"

eval "$(${prefix}/bin/conda shell.bash hook)"
conda init
