# dl-docker-run
Deep learning docker build and run

## create_my_dockerfile.sh
It creates a container with TensorFlow, PyTorch, Caffe2, and pushes to registry.
Run 'sh create_my_dockerfile.sh -h' to see the options.

## nvdrun.sh
'nvidia-docker run' abstracting some inputs, and some helper functions to keep track of the run container.
IP address of the running container is stored in ~/ipaddrs.
Worked files is stored in ~/nvdruns.
Run 'nvdrun.sh -h' to see the options.
