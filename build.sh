#! /bin/bash

#####################################################
# build.sh - script to build and push the
# sillsdev/aws-kubectl image to Docker Hub
#
# Usage:
#   build.sh [ tag1, tag2, ...]
#
# build.sh will build the sillsdev/aws-kubectl as
# an untagged image and push it to Docker Hub.  (Docker Hub
# will assign this image the tag "latest")
# For each tag provided as a command argument, it will:
#   - add the tag to the latest image that was just built
#   - push the image to Docker Hub

IMAGE=sillsdev/aws-kubectl
docker build -t ${IMAGE} -f Dockerfile .
docker push ${IMAGE}
while [ $# -gt 0 ] ; do
  docker tag ${IMAGE}:latest ${IMAGE}:$1
  docker push ${IMAGE}:$1
  shift
done
