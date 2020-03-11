#!/usr/bin/env bash

set -euxo pipefail

conda_prefix="$1"
python_version="$2"
env_name="$3"
ccache_prefix="$4"

cuda_ver=''
case "$(nvcc --version)" in
    *'V9.0.'*)
	cuda_ver=cuda90;;
    *'V9.2.'*)
	cuda_ver=cuda92;;
    *'V10.0.'*)
	cuda_ver=cuda100;;
    *'V10.1.'*)
	cuda_ver=cuda101;;
esac

if [ ! -z "${cuda_ver}" ]; then
    env_name="${env_name}-${cuda_ver}"
fi

# Setup Conda environment
export PATH="${conda_prefix}/condabin/:${PATH}"
eval "$(conda shell.bash hook)"
conda create --name "${env_name}" python="${python_version}"
conda activate "${env_name}"
conda install -y numpy pyyaml scipy ipython mkl mkl-include ninja cython hypothesis
conda install -y -c conda-forge ccache librosa
if [ ! -z "${cuda_ver}" ]; then
    conda install -y -c pytorch "magma-${cuda_ver}"
fi
conda clean -ya

mkdir "${ccache_prefix}"
mkdir "${ccache_prefix}/lib"
mkdir "${ccache_prefix}/cuda"

ln -s "${CONDA_PREFIX}/bin/ccache" "${ccache_prefix}/lib/cc"
ln -s "${CONDA_PREFIX}/bin/ccache" "${ccache_prefix}/lib/c++"
ln -s "${CONDA_PREFIX}/bin/ccache" "${ccache_prefix}/lib/gcc"
ln -s "${CONDA_PREFIX}/bin/ccache" "${ccache_prefix}/lib/g++"
ln -s "${CONDA_PREFIX}/bin/ccache" "${ccache_prefix}/cuda/nvcc"

printf '\n' >> "${HOME}/.bashrc"
printf 'conda activate %s\n' "${env_name}" >> "${HOME}/.bashrc"
printf 'export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}\n' >> "${HOME}/.bashrc"
printf 'export PATH="%s/lib:${PATH}"\n' "${ccache_prefix}" >> "${HOME}/.bashrc"
printf 'export CUDA_NVCC_EXECUTABLE="%s/cuda/nvcc"\n' "${ccache_prefix}" >> "${HOME}/.bashrc"

# Use ld from LLVM
package='clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04'
(
    cd "${HOME}"
    curl -sO "https://releases.llvm.org/8.0.0/${package}.tar.xz"
    tar -xf "${package}.tar.xz"
    sudo ln -s "${PWD}/${package}/bin/ld.lld" '/usr/local/bin/ld'
    rm "${package}.tar.xz"
)
