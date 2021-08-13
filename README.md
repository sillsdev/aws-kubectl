The Docker Image contains the aws-cli and kubectl. It is used to update the AWS ECR credentials periodically in a kubernetes cluster.

# Setup

You need to set your credentials in the aws-secrets.yml. Also you need to set your AWS_ACCOUNT, AWS_REGION and NAMESPACES in ecr-cron.yml.
Afterwords run:

```bash
aws.sh
```

Afterwords you should be able to see the cron job with:

```bash
kubectl get cronjobs -n infrastructure
```

# Thanks

This is a fork of the repository Odania-IT/aws-kubectl. The fork is to update from an
Alpine image to Ubuntu so that aws-cli version 2 can be installed.
