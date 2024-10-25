FROM ubuntu:22.04
# Resulting image is stored in https://hub.docker.com/r/sillsdev/aws-kubectl
# See https://github.com/sillsdev/aws-kubectl#readme for usage information.
LABEL maintainer="Danny Rorabaugh <daniel_rorabaugh@sil.org>"

# Default to x86/AMD64 if ARCH not specified with --build-arg
ARG ARCH=amd64

# Install AWS-CLI version 2
# See https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
RUN AWS_ARCH=$([ $ARCH == arm64 ] && echo aarch64 || echo x86_64) && \
  apt-get update && \
  apt-get install -y apt-utils curl zip && \
  apt-get autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  curl -sL https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip -o awscliv2.zip && \
  unzip awscliv2.zip && \
  aws/install && \
  rm -rf awscliv2.zip \
  aws \
  /usr/local/aws-cli/v2/*/dist/aws_completer \
  /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
  /usr/local/aws-cli/v2/*/dist/awscli/examples

# Install kubectl
# See https://kubernetes.io/docs/tasks/tools/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
  && mv kubectl /usr/local/bin \
  && chmod +x /usr/local/bin/kubectl

ENV HOME=/home/user

RUN adduser --system --group --uid 999 --home $HOME user
USER user
WORKDIR $HOME

ADD scripts/*.sh /usr/local/bin/
