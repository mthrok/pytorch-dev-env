#!/usr/bin/env bash

set -euxo pipefail

apt-get update
apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git bash-completion openssh-client \
  curl \
  ca-certificates \
  libjpeg-dev \
  libpng-dev \
  libsox-dev \
  less
rm -rf /var/lib/apt/lists/*
