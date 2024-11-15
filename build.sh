#! /bin/bash

######################################################################
# build.sh - script to build and push the aws-kubectl image
#
# Usage:
#   build.sh -v/--version VERSION [-a/--arch ARCH] [-i/--image IMAGE]
#
# Supported architectures: amd64, arm64
# Default architecture: amd64
# Default image: public.ecr.aws/thecombine/aws-kubectl
######################################################################

# Default arguments
ARCH=amd64
IMAGE="public.ecr.aws/thecombine/aws-kubectl"
VERSION=

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
    -v|--version)
      VERSION=$2
      shift
      ;;
    *)
      warning "Unrecognized option: $OPT"
      ;;
  esac
  shift
done

if [ -z "${VERSION}" ]; then
  echo "-v/--version required"
  exit 1
fi

echo "Image: ${IMAGE}"
echo "Tag: ${VERSION}-${ARCH}"
IMAGE=${IMAGE}:${VERSION}-${ARCH}

echo "Building and pushing"
docker build --platform=linux/${ARCH} --push -t ${IMAGE} .
