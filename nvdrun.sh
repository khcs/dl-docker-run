#!/bin/bash
# nvdrun.sh

if [[ "$1" == "-h" ]] ; then
    echo 'nvdrun.sh REGISTRY FRAMEWORK VERSION WORKSPACE'
    echo 'Example: nvdrun.sh XXXX.io caffe2 17.07 test'
fi

if [[ $# -eq 0 ]] ; then
    echo 'registry arg missing! - XXXX.io'
    exit 0
fi

if [[ $# -eq 1 ]] ; then
    echo 'framework arg missing! - ttensorflow, caffe2, etc.'
    exit 0
fi

if [[ $# -eq 2 ]] ; then
    echo 'framework version arg missing! - 17.XX, latest, etc.'
    exit 0
fi

if [[ $# -eq 3 ]] ; then
    echo 'workspace arg missing! - workspace/$arg'
    exit 0
fi

registry=$1
framework=$2
version=$3
workspace=$4

echo "${framework}_docker"

mkdir -p /tmp/nvdrun/$framework
mkdir -p ~/ipaddrs
ip addr > ~/ipaddrs/"${framework}_docker.ipaddr"

if [ ! -d ~/workspace/$workspace ]; then
    echo 'workspace directory does not exist!'
    exit 0
fi

cp -r ~/workspace/$workspace /tmp/nvdrun/$framework
nvidia-docker run -v /tmp/hshin/$framework:/home/workspace --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -ti --rm $registry/$framework /bin/bash
cp -r /tmp/hshin/$2 /datasets/flower_photos/tmp/$framework
rm ~/ipaddrs/"${framework}_docker.ipaddr"