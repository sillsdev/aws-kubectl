The Docker image is based off of `ubuntu:20.04` and adds:

- aws-cli version 2;
- the current stable release of kubectl; and
- a shell script, `ecr-get-login.sh` to perform the task of getting a docker
  login for the AWS Elastic Container Registry.

The default user is `user` whose home directory is `/home/user`.

# Running `ecr-get-login.sh`

The `ecr-get-login.sh` script will generate a login token to AWS ECR and store
it in a `kubernetes.io/dockerconfigjson` type Secret. The secret will be created
in each of the requested namespaces (see `NAMESPACES` under
[Environment Variables](#environment-variables)). The login token is valid for 12 hours.

## Environment Variables

`ecr-get-login.sh` requires the following environment variables to be set
before it is invoked:

| Variable Name         | Meaning                                                                                                                 |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| NAMESPACES            | A space-separated list of namespaces. `ecr-get-login.sh` will create the login secret in each of the namespaces listed. |
| SECRET_NAME           | The name of the Kubernetes secret to be created. This will be the what is listed in the `imagePullSecrets`              |
| DOCKER_EMAIL          | E-mail address to be listed in the `docker-registry` secret                                                             |
| AWS_ACCOUNT           | The 12-digit AWS account number                                                                                         |
| AWS_REGION            | The region, or availability zone, for the AWS_ACCOUNT                                                                   |
| AWS_ACCESS_KEY_ID     | ID for an access key that can read from AWS ECR                                                                         |
| AWS_SECRET_ACCESS_KEY | Secret for the access key to read from AWS ECR                                                                          |

When the `ecr-get-login.sh` script is run inside a Kubernetes Job, the `AWS_`
variables should be specified in Kubernetes opaque Secrets.
