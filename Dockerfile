# Resulting image is stored in https://gallery.ecr.aws/thecombine/aws-kubectl
# See https://github.com/sillsdev/aws-kubectl#readme for usage information
FROM ubuntu:24.04
LABEL maintainer="Danny Rorabaugh <daniel_rorabaugh@sil.org>"

# Use the <arch> from the --platform=<os>/<arch> flag
ARG TARGETARCH

# Update apt and install basic dependencies
RUN apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates curl unzip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install AWS-CLI version 2
# See https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
RUN AWS_ARCH=$(case $TARGETARCH in amd64) echo x86_64;; arm64) echo aarch64;; *) exit 1;; esac) && \
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
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH}/kubectl" \
  && mv kubectl /usr/local/bin \
  && chmod +x /usr/local/bin/kubectl

# Create non-root user with a fixed UID
ENV HOME=/home/user
RUN groupadd --system --gid 999 group \
  && useradd --system --uid 999 --gid 999 --home-dir $HOME --create-home --no-log-init user

# Add executable scripts without Windows carriage returns
COPY scripts/*.sh /usr/local/bin/
RUN sed -i 's/\r$//' /usr/local/bin/*.sh \
  && chmod +x /usr/local/bin/*.sh

# Change to non-root user
USER user
WORKDIR $HOME
