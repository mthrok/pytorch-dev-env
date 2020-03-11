#!/usr/bin/env bash

set -euxo pipefail

apt-get update
apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  curl \
  ca-certificates \
  libjpeg-dev \
  libpng-dev
rm -rf /var/lib/apt/lists/*
