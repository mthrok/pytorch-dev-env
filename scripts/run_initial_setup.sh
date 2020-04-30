#!/usr/bin/env bash
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
    ./packaging/build_from_source.sh "$PWD"
    IS_CONDA=1 python setup.py develop
)

if [ ! -d torchvision]; then
    git clone https://github.com/pytorch/vision torchvision
fi
(
    cd torchvision
    python setup.py develop
)

if [ ! -d torchtext]; then
    git clone https://github.com/pytorch/text torchtext
fi
(
    cd torchtext
    python setup.py develop
)
