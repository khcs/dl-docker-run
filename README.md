# dl-docker-run
Deep learning docker build and run

## create_my_dockerfile.sh
It creates a container pulling from the latest Dockerfiles of TensorFlow, PyTorch, Caffe2, and to be pushed to a registry.
Customizations can be added to the [dockerfile_additional.txt](https://github.com/khcs/dl-docker-run/blob/master/dockerfile_additional.txt).

Run 
```bash
sh create_my_dockerfile.sh -h
```
to see the options.

## nvdrun.sh
'nvidia-docker run' abstracting some inputs, and some helper functions to keep track of the run container.

IP address of the running container is stored in ~/ipaddrs.

Worked files is stored in ~/nvdruns.

Run 
```bash
sh nvdrun.sh -h
```
to see the options.
