#!/bin/bash
# create_my_dockerfile.sh

if [[ "$1" == "-h" ]] ; then
    echo 'create_my_dockerfile.sh REGISTRY FRAMEWORK'
    echo 'Example: create_my_dockerfile.sh XXXX.io my-dl-frameworks'
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
    echo 'framework arg missing! - my-dl-frameworks, caffe2, etc.'
    exit 0
fi

registry=$1
workgroup=$2
framework=$3/

mkdir /tmp/dl-docker-run
git clone https://github.com/tensorflow/tensorflow /tmp/dl-docker-run/tensorflow
git clone -b gh-pages https://github.com/caffe2/caffe2.git /tmp/dl-docker-run/caffe2-gh-pages

rm -f /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile

echo '####################' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '# start TensorFlow #' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '####################' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile

# TensorFlow
cat /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/Dockerfile.devel-gpu dockerfile_additional.txt >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile

echo '####################' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '#  start PyTorch   #' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '####################' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile

# PyTorch
# ignore docker build for now
#git clone https://github.com/pytorch/pytorch.git /tmp/dl-docker-run/pytorch
#sed '6,999!d' /tmp/dl-docker-run/pytorch/Dockerfile >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
#cp /tmp/dl-docker-run/pytorch/setup.py requirements.txt /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/
#cp -r /tmp/dl-docker-run/pytorch/tools /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/
#cp -r /tmp/dl-docker-run/pytorch/torch /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/
# do pip install instead
echo 'RUN pip install http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp27-none-linux_x86_64.whl' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo 'RUN pip install torchvision' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile

echo '####################' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '#  start Caffe2    #' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '####################' >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile

# Caffe2
sed '6,999!d' /tmp/dl-docker-run/caffe2-gh-pages/docker/ubuntu-16.04-gpu-all-options/Dockerfile >> /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile

docker build -t $resigtry/$workgroup/$framework -f /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker/my_Dockerfile /tmp/dl-docker-run/tensorflow/tensorflow/tools/docker