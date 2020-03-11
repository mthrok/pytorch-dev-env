FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ARG USERNAME
ARG UID
ARG GID

ARG PYTHON_VERSION=3.8
ARG CONDA_ENV_NAME="PY${PYTHON_VERSION}"

# The followings are meant for temporary variables during build, not to be changed by CLI
ARG HOMEDIR="/home/${USERNAME}"
ARG CONDA_BASE_DIR="${HOMEDIR}/conda"

# Setup user:group permissions and sudo without password
# Without `--no-log-init`, `useradd` hangs and create infinite size file
# https://github.com/moby/moby/issues/5419#issuecomment-41478290
RUN addgroup --gid "$GID" "$USERNAME" &&\
    useradd --no-log-init --create-home --home-dir "$HOMEDIR" \
	--uid "$UID" --gid "$GID" --shell /bin/bash "$USERNAME" && \
    usermod -aG sudo "$USERNAME" &&\
    apt update && apt install -y sudo && rm -rf /var/lib/apt/lists/* &&\
    printf '\n%s     ALL=(ALL) NOPASSWD:ALL\n' "$USERNAME" >> /etc/sudoers

WORKDIR "$HOMEDIR"
USER "$USERNAME"
ADD . .
RUN sudo ./scripts/install_prereqs.sh &&\
    ./scripts/install_conda.sh "${CONDA_BASE_DIR}" &&\
    ./scripts/setup_conda_env.sh "${CONDA_BASE_DIR}" "${PYTHON_VERSION}" "${CONDA_ENV_NAME}" "${HOMEDIR}/ccache"
