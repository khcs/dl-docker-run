#!/bin/bash
# nvdrun.sh

if [[ "$1" == "-h" ]] ; then
    echo 'nvdrun.sh WORKSPACE [DATASET_DIR: optional]'
    echo 'Example: nvdrun.sh test [/tmp/datasets]'
    exit 0
fi

if [[ $# -eq 0 ]] ; then
    echo 'workspace arg missing! - workspace/$arg'
    exit 0
fi

framework=tensorflow
workgroup=tensorflow
tag=latest-gpu-py3
workspace=$1

if [[ $# -eq 1 ]] ; then
    :
else
    dataset_dir=$2
fi

mkdir -p /tmp/nvdrun/$framework
mkdir -p ~/ipaddrs
mkdir -p ~/nvdruns
ip addr > ~/ipaddrs/"${framework}_docker.ipaddr"

if [ ! -d ~/workspace/$workspace ]; then
    echo 'workspace directory does not exist!'
    exit 0
fi

if [[ $# -eq 5 ]] ; then
    rsync -rv --exclude=.git ~/workspace/$workspace /tmp/nvdrun/$framework > /dev/null 2>&1
    nvidia-docker run -v /tmp/nvdrun/$framework:/home/workspace --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -ti -p 8888:8888 -p 6006:6006 $workgroup/$framework:$tag /bin/bash
else

    if [ ! -d $dataset_dir ]; then
        echo 'dataset directory does not exist!'
        exit 0
    fi
    
    rsync -rv --exclude=.git ~/workspace/$workspace /tmp/nvdrun/$framework > /dev/null 2>&1
    nvidia-docker run -v /tmp/nvdrun/$framework:/home/workspace -v $dataset_dir:/datasets --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -ti -p 8888:8888 -p 6006:6006 $workgroup/$framework:$tag /bin/bash
fi

rsync -rv --exclude=.git /tmp/nvdrun/$framework ~/nvdruns > /dev/null 2>&1
rm ~/ipaddrs/"${framework}_docker.ipaddr"

