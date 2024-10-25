#! /bin/bash

#####################################################
# build.sh - script to build and push the
# sillsdev/aws-kubectl image to Docker Hub
#
# Usage:
#   build.sh [ tag1, tag2, ...]
#
# build.sh will build the sillsdev/aws-kubectl as
# an untagged image and push it to Docker Hub.
# (Docker Hub will assign this image the tag "latest".)
# For each tag provided as a command argument, it will:
#   - add the tag to the latest image that was just built
#   - push the image to Docker Hub
#
# Supported architectures: amd64, arm64
#####################################################

ARCH=$(case $(uname -m) in *86*) echo amd64;; *aarch*) echo arm64;; *arm*) echo arm64;; esac)
echo "Architecture: $ARCH"

IMAGE=sillsdev/aws-kubectl
echo "Image: $IMAGE"

echo "Building..."
docker build -t ${IMAGE} -f Dockerfile . --build-arg=ARCH=$ARCH

echo "Pushing..."
docker push ${IMAGE}
while [ $# -gt 0 ] ; do
  docker tag ${IMAGE}:latest ${IMAGE}:$1
  docker push ${IMAGE}:$1
  shift
done
