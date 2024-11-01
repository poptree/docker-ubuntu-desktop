#!/bin/bash

# usage: ./docker_build.sh 20.04-cu11.0.3 [baseimage] [IS_CHINA]

# echo "argv: $1"
UBUNTU_VERSION=`echo $1 | awk -F '-cu' '{print $1}'`
CUDA_VERSION=`echo $1 | awk -F '-cu' '{print $2}'`
echo "ubuntu version:${UBUNTU_VERSION},cuda version:${CUDA_VERSION}"

# check ubuntu version
if [[ ${UBUNTU_VERSION} == "custom" ]]; then
    echo "Using custom image"
elif [[(${UBUNTU_VERSION} != "18.04") && (${UBUNTU_VERSION} != "20.04") && (${UBUNTU_VERSION} != "22.04") && (${UBUNTU_VERSION} != "24.04")]];then
    echo "Invalid ubuntu version:${UBUNTU_VERSION}"
    exit -1
fi

IS_CHINA=false
if [ $# -ge 3 ]; then
IS_CHINA=$3
fi
echo ${IS_CHINA}

# pull base image (ubuntu/cuda)
if [ $# -ge 2 ]; then
    BASE_IMAGE=$2
elif [[("${CUDA_VERSION}" == "")]];then
    BASE_IMAGE=ubuntu:${UBUNTU_VERSION}
else
    BASE_IMAGE=nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION}
fi
echo ${BASE_IMAGE}

docker pull ${BASE_IMAGE}
if [[ $? != 0 ]]; then 
    echo "Failed to pull docker image '${BASE_IMAGE}'"
    exit -2
fi

# build ubuntu-desktop image
if [ $# -ge 2 ]; then
    DOCKER_TAG="custom"
elif [[("${CUDA_VERSION}" == "")]];then
    DOCKER_TAG=${UBUNTU_VERSION}
else
    DOCKER_TAG=${UBUNTU_VERSION}-cu${CUDA_VERSION}
fi
echo "docker build ubuntu-desktop --file ubuntu-desktop/${UBUNTU_VERSION}/Dockerfile \
             --build-arg BASE_IMAGE=${BASE_IMAGE} \
             --build-arg IS_CHINA=${IS_CHINA} \
             --tag ubuntu-desktop:${DOCKER_TAG}"
docker build ubuntu-desktop --file ubuntu-desktop/${UBUNTU_VERSION}/Dockerfile \
             --build-arg BASE_IMAGE=${BASE_IMAGE} \
             --build-arg IS_CHINA=${IS_CHINA} \
             --tag ubuntu-desktop:${DOCKER_TAG}
if [[ $? != 0 ]]; then 
    echo "Failed to build docker image 'ubuntu-desktop:${DOCKER_TAG}'"
    exit -3
fi

exit 0
