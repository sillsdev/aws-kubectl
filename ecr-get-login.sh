#!/usr/bin/env sh
set -e

echo "Retrieving Docker Credentials for the AWS ECR Registry ${AWS_ACCOUNT}"
DOCKER_REGISTRY_SERVER=https://${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
DOCKER_USER=AWS
DOCKER_PASSWORD=`aws ecr get-login --region ${AWS_REGION} --registry-ids ${AWS_ACCOUNT} | cut -d' ' -f6`

for namespace in ${NAMESPACES}
do
	echo
	echo "Working in Namespace ${namespace}"
	echo
	echo "Removing previous secret in namespace ${namespace}"
	kubectl --namespace=${namespace} delete --ignore-not-found secret ${SECRET_NAME}

	echo "Creating new secret in namespace ${namespace}"
	kubectl create secret docker-registry ${SECRET_NAME} \
		--docker-server=$DOCKER_REGISTRY_SERVER \
		--docker-username=$DOCKER_USER \
		--docker-password=$DOCKER_PASSWORD \
		--docker-email=${DOCKER_EMAIL} \
		--namespace=${namespace}
done

echo "Patching default serviceaccount"
echo kubectl patch serviceaccount default -p '{"imagePullSecrets":[{"name":"aws-registry"}]}'
