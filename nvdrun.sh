#!/bin/bash
# nvdrun.sh

if [[ "$1" == "-h" ]] ; then
    echo 'nvdrun.sh REGISTRY WORKGROUP FRAMEWORK TAG WORKSPACE [DATASET_DIR: optional]'
    echo 'Example: nvdrun.sh XXXX.io tensorflow tensorflow 17.XX test [/tmp/datasets]'
    exit 0
fi

if [[ $# -eq 0 ]] ; then
    echo 'registry arg missing! - XXXX.io'
    exit 0
fi

if [[ $# -eq 1 ]] ; then
    echo 'workgroup arg missing! - tensorflow, nvidian, etc.'
    exit 0
fi

if [[ $# -eq 2 ]] ; then
    echo 'framework arg missing! - tensorflow, caffe2, etc.'
    exit 0
fi

if [[ $# -eq 3 ]] ; then
    echo 'framework tag arg missing! - 17.XX, latest, etc.'
    exit 0
fi

if [[ $# -eq 4 ]] ; then
    echo 'workspace arg missing! - workspace/$arg'
    exit 0
fi

registry=$1
workgroup=$2
framework=$3
tag=$4
workspace=$5

if [[ $# -eq 5 ]] ; then
    :
else
    dataset_dir=$6
fi

mkdir -p /tmp/nvdrun/$framework
mkdir -p ~/ipaddrs
mkdir -p ~/nvdruns
ip addr > ~/ipaddrs/"${framework}_docker.ipaddr"

if [ ! -d ~/workspace/$workspace ]; then
    echo 'workspace directory does not exist!'
    exit 0
fi

rsync -rv --exclude=.git ~/workspace/$workspace /tmp/nvdrun/$framework

if [[ $# -eq 5 ]] ; then
    nvidia-docker run -v /tmp/nvdrun/$framework:/home/workspace --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -ti -p 8888:8888 -p 6006:6006 $registry/$workgroup/$framework:$tag /bin/bash
else
    nvidia-docker run -v /tmp/nvdrun/$framework:/home/workspace -v $dataset_dir:/datasets --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -ti -p 8888:8888 -p 6006:6006 $registry/$workgroup/$framework:$tag /bin/bash
fi

rsync -rv --exclude=.git /tmp/nvdrun/$framework ~/nvdruns/$framework
rm ~/ipaddrs/"${framework}_docker.ipaddr"
