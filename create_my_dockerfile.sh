mkdir /tmp/nvdrun
git clone https://github.com/tensorflow/tensorflow /tmp/nvdrun/tensorflow
git clone -b gh-pages https://github.com/caffe2/caffe2.git /tmp/nvdrun/caffe2-gh-pages

rm -f /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile

echo '####################' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '# start TensorFlow #' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '####################' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile

# TensorFlow
cat /tmp/nvdrun/tensorflow/tensorflow/tools/docker/Dockerfile.devel-gpu dockerfile_additional.txt >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile

echo '####################' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '#  start PyTorch   #' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '####################' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile

# PyTorch
# ignore docker build for now
#git clone https://github.com/pytorch/pytorch.git /tmp/nvdrun/pytorch
#sed '6,999!d' /tmp/nvdrun/pytorch/Dockerfile >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
#cp /tmp/nvdrun/pytorch/setup.py requirements.txt /tmp/nvdrun/tensorflow/tensorflow/tools/docker/
#cp -r /tmp/nvdrun/pytorch/tools /tmp/nvdrun/tensorflow/tensorflow/tools/docker/
#cp -r /tmp/nvdrun/pytorch/torch /tmp/nvdrun/tensorflow/tensorflow/tools/docker/
# do pip install instead
echo 'RUN pip install http://download.pytorch.org/whl/cu80/torch-0.1.12.post2-cp27-none-linux_x86_64.whl' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo 'RUN pip install torchvision' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile

echo '####################' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '#  start Caffe2    #' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile
echo '####################' >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile

# Caffe2
sed '6,999!d' /tmp/nvdrun/caffe2-gh-pages/docker/ubuntu-16.04-gpu-all-options/Dockerfile >> /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile

docker build -t nvcr.io/nvidian_sas/pushed-nvdrun -f /tmp/nvdrun/tensorflow/tensorflow/tools/docker/my_Dockerfile /tmp/nvdrun/tensorflow/tensorflow/tools/docker