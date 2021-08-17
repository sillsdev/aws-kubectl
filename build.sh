#! /bin/bash

docker build -t sillsdev/aws-kubectl -f Dockerfile .
docker push sillsdev/aws-kubectl
while [ $# -gt 0 ] ; do
  docker tag sillsdev/aws-kubectl:latest sillsdev/aws-kubectl:$1
  docker push sillsdev/aws-kubectl:$1
  shift
done
