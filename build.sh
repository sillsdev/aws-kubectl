#! /bin/bash

###############################################################
# build.sh - script to build and push the aws-kubectl image
#
# Usage:
#   build.sh [-a/--arch ARCH] [-i/--image IMAGE] [-t/--tag TAG]
#
# Supported architectures: amd64, arm64
# Default architecture: amd64
# Default image: public.ecr.aws/thecombine/aws-kubectl
# Default tag: latest
###############################################################

# Default arguments
ARCH=amd64
IMAGE="public.ecr.aws/thecombine/aws-kubectl"
TAG=

# Parse arguments to customize installation
while (( "$#" )) ; do
  OPT=$1
  case $OPT in
    -a|--arch)
      ARCH=$2
      shift
      ;;
    -i|--image)
      IMAGE=$2
      shift
      ;;
    -t|--tag)
      TAG=$2
      shift
      ;;
    *)
      warning "Unrecognized option: $OPT"
      ;;
  esac
  shift
done

echo "Architecture(s): ${ARCH}"
echo "Image: ${IMAGE}"
if [ -n "${TAG}" ]; then
  echo "Tag: ${TAG}"
  IMAGE=${IMAGE}:${TAG}
fi

echo "Building and pushing"
docker build --build-arg=ARCH=${ARCH} --platform=linux/${ARCH} --push -t ${IMAGE} .
