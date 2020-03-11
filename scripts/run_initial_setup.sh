#!/usr/bin/env bash
sudo apt update
sudo apt install -y emacs bash-completion less openssh-client
sudo rm -rf /var/lib/apt/lists/*

if [ ! -d pytorch ]; then
    git clone https://github.com/pytorch/pytorch
fi
(
    cd pytorch
    git submodule update --init --recursive
    python setup.py develop
)

if [ ! -d torchaudio]; then
    git clone https://github.com/pytorch/audio torchaudio
fi
(
    cd torchaudio
    python setup.py develop
)
